PREVIOUS_TRAIN_LAG_TIME = 5
CLOSING_TIME = 10
RED_THRESHOLD = 10
YELLOW_THRESHOLD = 30

class @Crossing
  constructor: (@name, @distance, @latitude, @longitude, @updated_at) ->
    @closings = []

  # * осталось более часа — зеленый
  # * осталось примерно 55/50/.../20 минут — желтый
  # * осталось примерно 15/10/5 минут — красный
  # * вероятно уже закрыт — красный
  # * Аллегро только что прошел — желтый
  state: ->
    return 'Closed' if @name == 'Поклонногорская'
    return 'Unknown' unless @hasSchedule()

    currentTime = util.minutes_since_midnight()
    trainTime = @currentClosing().trainTime
    timeTillClosing = trainTime - CLOSING_TIME - currentTime

    return 'Clear'      if currentTime >  trainTime + PREVIOUS_TRAIN_LAG_TIME # next train will be tomorrow
    return 'JustOpened' if currentTime >= trainTime && currentTime <= trainTime + PREVIOUS_TRAIN_LAG_TIME
    return 'Closed'     if currentTime >= trainTime - CLOSING_TIME && currentTime < trainTime
    return 'Clear'      if timeTillClosing > 60
    return 'Soon'       if timeTillClosing > YELLOW_THRESHOLD
    return 'VerySoon'   if timeTillClosing > RED_THRESHOLD
    return 'Closing'    if timeTillClosing > 0
    return 'Closed'

  color: ->
    switch @state()
      when 'Clear'      then 'Green'
      when 'Soon'       then 'Green'
      when 'VerySoon'   then 'Yellow'
      when 'Closing'    then 'Red'
      when 'Closed'     then 'Red'
      when 'JustOpened' then 'Yellow'
      when 'Unknown'    then 'Gray'
      else 'Green'

  subtitle: ->
    return 'Закрыто на ремонт' if @name == 'Поклонногорская'

    minutesTillClosing = @minutesTillClosing()
    minutesTillOpening = @minutesTillOpening()
    minutesSinceOpening = @minutesSinceOpening()

    switch @state()
      when 'Clear', 'Soon', 'VerySoon', 'Closing'
        if minutesTillClosing == 0 then 'Только что закрыли' else "Закроют через #{util.minutes_as_text minutesTillClosing}"
      when 'Closed'
        if minutesTillOpening == 0 then 'Только что открыли' else "Откроют через #{util.minutes_as_text minutesTillOpening}"
      when 'JustOpened'
        if minutesSinceOpening == 0 then 'Только что открыли' else "Открыли #{util.minutes_as_text minutesSinceOpening} назад"
      when 'Unknown'
        "Расписания нет"
      else
        null

  todayClosings: ->
    @closings.filter (c) -> c.train().runsOn()

  # the first closing later than now, otherwise the first closing available
  nextClosing: ->
    currentTime = util.minutes_since_midnight()
    for closing in @todayClosings()
      return closing if closing.trainTime >= currentTime
    _.first @closings

  # the first closing earlier than now, or the last available
  previousClosing: ->
    currentTime = util.minutes_since_midnight()
    for closing in @todayClosings().slice(0).reverse()
      return closing if closing.trainTime <= currentTime
    _.last @closings

  currentClosing: ->
    currentTime = util.minutes_since_midnight()
    nextClosing = @nextClosing()
    previousClosing = @previousClosing()
    if currentTime <= previousClosing.trainTime + PREVIOUS_TRAIN_LAG_TIME && currentTime >= previousClosing.trainTime
      previousClosing
    else
      nextClosing

  minutesTillClosing: ->
    @minutesTillOpening() - CLOSING_TIME

  minutesTillOpening: ->
    trainTime = @nextClosing().trainTime
    currentTime = util.minutes_since_midnight()
    result = trainTime - currentTime
    result = 24 * 60 + result if result < 0
    result

  minutesSinceOpening: ->
    previousTrainTime = @previousClosing().trainTime
    currentTime = util.minutes_since_midnight()
    result = currentTime - previousTrainTime;
    result = 24 * 60 + result if (result < 0)
    result

  isClosest: -> this == Crossing.closest()
  isCurrent: -> this == Crossing.current()
  isClosed: -> @state == 'Closed'
  isDisabled: -> @name == 'Поклонногорская'
  hasSchedule: -> @closings.length > 0

  valueOf: -> "<Crossing: #{@name}, #{@latitude}, #{@longitude}, #{@closings.length}>"
  toString: -> @valueOf()

  distanceFrom: (lat, lng) -> util.distance_between_lat_lng_in_km(@latitude, @longitude, lat, lng)
  closingsForFromRussiaTrains: -> @closings.filter (closing) -> closing.toFinland()
  closingsForFromFinlandTrains: -> @closings.filter (closing) -> closing.toRussia()

  sortClosingsByTime: -> @closings = @closings.sort (c1, c2) -> c1.trainTime - c2.trainTime
  addClosing: (rawTime, crossing, trainNumber) -> @closings.push new Closing(rawTime, crossing, trainNumber)
  makeCurrent: -> Crossing.setCurrent(this)


  @get: (name) ->
    for crossing in ds.crossings
      return crossing if crossing.name == name
    null

  @default: -> @get "Удельная"
  @closest: -> ds.closestCrossing
  @selected: -> localStorage.selectedCrossing && @get localStorage.selectedCrossing
  @current: -> @selected() || @closest() || @default()

  @setSelected: (crossing) ->
    localStorage.selectedCrossing = crossing && crossing.name || null
    util.trigger(MODEL_UPDATED, 'Crossing.setSelected')

  @setCurrent: (crossing) ->
    if crossing.isClosest()
      delete localStorage.selectedCrossing
      util.trigger(MODEL_UPDATED, 'Crossing.setCurrent')
    else
      @setSelected crossing

  @setCurrentToClosest: ->
    @setCurrent ds.closestCrossing if ds.closestCrossing

  @reversed: -> ds.crossings_reversed ||= ds.crossings.slice(0).reverse()
  @active: -> ds.crossings_active ||= ds.crossings.filter (crossing) -> crossing.hasSchedule() && !crossing.isDisabled()

  @closestTo: (coords) ->
    closest_crossing = null
    closest_distance = Infinity
    for crossing in ds.crossings when !crossing.isDisabled()
      distance = crossing.distanceFrom(coords.latitude, coords.longitude)
      if distance < closest_distance
        closest_crossing = crossing
        closest_distance = distance
    closest_crossing

  @closestToCurrentPosition: ->
    @closestTo ds.position.coords

  @updateClosest: (coords) ->
    newClosest = @closestTo(coords)
    if newClosest != ds.closestCrossing
      ds.closestCrossing = newClosest
      util.trigger(MODEL_UPDATED, 'Crossing.updateClosest')
