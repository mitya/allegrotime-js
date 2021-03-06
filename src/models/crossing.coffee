import Closing from './closing'

export default class Crossing
  PREVIOUS_TRAIN_LAG_TIME = 5
  CLOSING_TIME = 10
  RED_THRESHOLD = 10
  YELLOW_THRESHOLD = 30

  constructor: (@name, @distance, @latitude, @longitude, @updated_at) ->
    @closings = []

  # * осталось более часа — зеленый
  # * осталось примерно 55/50/.../20 минут — желтый
  # * осталось примерно 15/10/5 минут — красный
  # * вероятно уже закрыт — красный
  # * Аллегро только что прошел — желтый
  @prop 'state', ->
    return 'Closed' if @name == 'Поклонногорская'
    return 'Unknown' unless @hasSchedule

    currentTime = $U.minutesSinceMidnight()
    trainTime = @currentClosing.trainTime
    timeTillClosing = trainTime - CLOSING_TIME - currentTime

    return 'Clear'      if currentTime >  trainTime + PREVIOUS_TRAIN_LAG_TIME # next train will be tomorrow
    return 'JustOpened' if currentTime >= trainTime && currentTime <= trainTime + PREVIOUS_TRAIN_LAG_TIME
    return 'Closed'     if currentTime >= trainTime - CLOSING_TIME && currentTime < trainTime
    return 'Clear'      if timeTillClosing > 60
    return 'Soon'       if timeTillClosing > YELLOW_THRESHOLD
    return 'VerySoon'   if timeTillClosing > RED_THRESHOLD
    return 'Closing'    if timeTillClosing > 0
    return 'Closed'

  @prop 'color', ->
    switch @state
      when 'Clear'      then 'Green'
      when 'Soon'       then 'Green'
      when 'VerySoon'   then 'Yellow'
      when 'Closing'    then 'Red'
      when 'Closed'     then 'Red'
      when 'JustOpened' then 'Yellow'
      when 'Unknown'    then 'Gray'
      else 'Green'

  @prop 'subtitle', ->
    return 'Закрыто на ремонт' if @name == 'Поклонногорская'

    minutesTillClosing = @minutesTillClosing
    minutesTillOpening = @minutesTillOpening
    minutesSinceOpening = @minutesSinceOpening

    switch @state
      when 'Clear', 'Soon', 'VerySoon', 'Closing'
        if minutesTillClosing == 0 then 'Только что закрыли' else "Закроют через #{$U.minutesAsText minutesTillClosing}"
      when 'Closed'
        if minutesTillOpening == 0 then 'Только что открыли' else "Откроют через #{$U.minutesAsText minutesTillOpening}"
      when 'JustOpened'
        if minutesSinceOpening == 0 then 'Только что открыли' else "Открыли #{$U.minutesAsText minutesSinceOpening} назад"
      when 'Unknown'
        "Расписания нет"
      else
        null

  # the first closing later than now, otherwise the first closing available
  @prop 'nextClosing', ->
    currentTime = $U.minutesSinceMidnight()
    for closing in @todayClosings
      return closing if closing.trainTime >= currentTime
    _.first @closings

  # the first closing earlier than now, or the last available
  @prop 'previousClosing', ->
    currentTime = $U.minutesSinceMidnight()
    for closing in @todayClosings.slice(0).reverse()
      return closing if closing.trainTime <= currentTime
    _.last @closings

  @prop 'currentClosing', ->
    currentTime = $U.minutesSinceMidnight()
    nextClosing = @nextClosing
    previousClosing = @previousClosing
    if currentTime <= previousClosing.trainTime + PREVIOUS_TRAIN_LAG_TIME && currentTime >= previousClosing.trainTime
      previousClosing
    else
      nextClosing

  @prop 'todayClosings', -> @closings.filter (c) -> c.train.runsOn()
  @prop 'closingsForFromRussiaTrains', -> @closings.filter (closing) -> closing.toFinland
  @prop 'closingsForFromFinlandTrains', -> @closings.filter (closing) -> closing.toRussia

  @prop 'minutesTillClosing', ->
    @minutesTillOpening - CLOSING_TIME

  @prop 'minutesTillOpening', ->
    trainTime = @nextClosing.trainTime
    currentTime = $U.minutesSinceMidnight()
    result = trainTime - currentTime
    result = 24 * 60 + result if result < 0
    result

  @prop 'minutesSinceOpening', ->
    previousTrainTime = @previousClosing.trainTime
    currentTime = $U.minutesSinceMidnight()
    result = currentTime - previousTrainTime
    result = 24 * 60 + result if result < 0
    result

  @prop 'isClosest', -> @ == Crossing.closest
  @prop 'isCurrent', -> @ == Crossing.current
  @prop 'isClosed', -> @state == 'Closed'
  @prop 'isDisabled', -> @name == 'Поклонногорская'
  @prop 'hasSchedule', -> @closings.length > 0


  valueOf: -> "<Crossing: #{@name}, #{@latitude}, #{@longitude}, #{@closings.length}>"
  toString: -> @valueOf()

  distanceFrom: (lat, lng) -> $U.distanceBetweenLatLngInKm(@latitude, @longitude, lat, lng)

  sortClosingsByTime: -> @closings = @closings.sort (c1, c2) -> c1.trainTime - c2.trainTime
  addClosing: (rawTime, crossing, trainNumber) -> @closings.push new Closing(rawTime, crossing, trainNumber)
  makeCurrent: -> @constructor.setCurrent(this)

  @get: (name) ->
    for crossing in appState.crossings
      return crossing if crossing.name == name
    null

  @cprop 'initial', -> @get "Удельная"
  @cprop 'closest', -> appState.closestCrossing
  @cprop 'selected', -> localStorage.selectedCrossing && @get localStorage.selectedCrossing
  @cprop 'current', -> @selected || @closest || @initial

  @setSelected: (crossing) ->
    localStorage.selectedCrossing = crossing && crossing.name || null
    app.trigger(MODEL_UPDATED, 'Crossing.setSelected')

  @setCurrent: (crossing) ->
    if crossing.isClosest
      delete localStorage.selectedCrossing
      app.trigger(MODEL_UPDATED, 'Crossing.setCurrent')
    else
      @setSelected crossing

  @setCurrentToClosest: ->
    @setCurrent appState.closestCrossing if appState.closestCrossing

  @cprop 'reversed', -> appState.crossings_reversed ||= appState.crossings.slice(0).reverse()
  @cprop 'active', -> appState.crossings_active ||= appState.crossings.filter (crossing) -> crossing.hasSchedule && !crossing.isDisabled
  @cprop 'closestToCurrentPosition', -> @closestTo appState.position.coords

  @closestTo: (coords) ->
    closest_crossing = null
    closest_distance = Infinity
    for crossing in appState.crossings when !crossing.isDisabled
      distance = crossing.distanceFrom(coords.latitude, coords.longitude)
      if distance < closest_distance
        closest_crossing = crossing
        closest_distance = distance
    closest_crossing

  @updateClosest: (coords) ->
    newClosest = @closestTo(coords)
    if newClosest != appState.closestCrossing
      appState.closestCrossing = newClosest
      app.trigger(MODEL_UPDATED, 'Crossing.updateClosest')
