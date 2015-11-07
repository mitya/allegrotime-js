PREVIOUS_TRAIN_LAG_TIME = 5
CLOSING_TIME = 10
RED_THRESHOLD = 10
YELLOW_THRESHOLD = 30

class @Crossing
  # props: name, latitude, longitude, closings, distance

  constructor: (@name) ->
    @closings = []

  # - осталось более часа — зеленый
  # - осталось примерно 55/50/.../20 минут — желтый
  # - осталось примерно 15/10/5 минут — красный
  # - вероятно уже закрыт — красный
  # - Аллегро только что прошел — желтый
  state: ->
    return 'Closed' if @name == 'Поклонногорская'
    return 'Unknown' unless @hasSchedule()

    currentTime = Helper.minutes_since_midnight()
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

  # coordinate: ->
  #   CLLocationCoordinate2DMake(latitude, longitude)
  #
  # title: ->
  #   localizedName
  #
  # localizedName: ->
  #   name.l

  subtitle: ->
    return 'Закрыто на ремонт' if @name == 'Поклонногорская'

    minutesTillClosing = @minutesTillClosing()
    minutesTillOpening = @minutesTillOpening()
    minutesSinceOpening = @minutesSinceOpening()

    switch @state()
      when 'Clear', 'Soon', 'VerySoon', 'Closing'
        if minutesTillClosing == 0 then 'Только что закрыли' else "Закроют через #{Helper.minutes_as_text minutesTillClosing}"
      when 'Closed'
        if minutesTillOpening == 0 then 'Только что открыли' else "Откроют через #{Helper.minutes_as_text minutesTillOpening}"
      when 'JustOpened'
        if minutesSinceOpening == 0 then 'Только что открыли' else "Открыли #{Helper.minutes_as_text minutesSinceOpening} назад"
      when 'Unknown'
        "Расписания нет"
      else
        null

  # triggerSubtitleChanged: ->
  #   willChangeValueForKey('subtitle')
  #   didChangeValueForKey('subtitle')

  todayClosings: ->
    @closings.filter( (cl) -> cl.train().runsOn() )

  # the first closing later than now, otherwise the first closing available
  nextClosing: ->
    currentTime = Helper.minutes_since_midnight()
    for closing in @todayClosings()
      return closing if closing.trainTime >= currentTime
    @closings[0]

  # the first closing earlier than now, or the last available
  previousClosing: ->
    currentTime = Helper.minutes_since_midnight()
    for closing in @todayClosings().slice(0).reverse()
      return closing if closing.trainTime <= currentTime
    _.last @closings

  currentClosing: ->
    currentTime = Helper.minutes_since_midnight()
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
    currentTime = Helper.minutes_since_midnight()
    result = trainTime - currentTime
    result = 24 * 60 + result if result < 0
    result

  minutesSinceOpening: ->
    previousTrainTime = @previousClosing().trainTime
    currentTime = Helper.minutes_since_midnight()
    result = currentTime - previousTrainTime;
    result = 24 * 60 + result if (result < 0)
    result

  isClosest: -> this == Crossing.closest()

  isCurrent: -> this == Crossing.current()

  index: -> Crossing.crossings[this]

  toTrackingKey: -> @name

  isClosed: -> @state == 'Closed'

  isDisabled: -> @name == 'Поклонногорская'

  hasSchedule: -> @closings.length > 0

  valueOf: -> "<Crossing: #{@name}, #{@latitude}, #{@longitude}, #{@closings.length}>"

  toString: -> @valueOf()

  distanceFrom: (lat, lng) ->
    Helper.distance_between_lat_lng_in_km(@latitude, @longitude, lat, lng)

  sortClosingsByTime: ->
    @closings = @closings.sort (c1, c2) -> c1.trainTime - c2.trainTime

  closingsForFromRussiaTrains: ->
    @closings.filter (closing) -> closing.toFinland()

  closingsForFromFinlandTrains: ->
    @closings.filter (closing) -> closing.toRussia()


  @crossingWithName: (name, latitude:lat, longitude:lng) ->
    crossing = new
    crossing.name = name;
    crossing.latitude = lat;
    crossing.longitude = lng;
    crossing.closings = NSMutableArray.arrayWithCapacity(8)
    crossing

  @get: (name) ->
    for crossing in @crossings
      return crossing if crossing.name == name
    console.warn "ERROR #{__method__}: crossing is not found for name = '#{name}'"
    null

  @default: ->
    @get "Удельная"

  @closest: ->
    @_closest

  @selected: ->
    localStorage.selectedCrossing && @get localStorage.selectedCrossing

  @current: ->
    @selected() || @closest() || @default()

  @setSelected: (crossing) ->
    localStorage.selectedCrossing = crossing && crossing.name || null
    $(document).trigger('model-updated')

  @setCurrent: (crossing) ->
    if crossing.isClosest()
      delete localStorage.selectedCrossing
      $(document).trigger('model-updated')
    else
      @setSelected crossing

  @setCurrentToClosest: ->
    @setCurrent @_closest if @_closest

  @reversed: ->
    @_reversed ||= @crossings.slice(0).reverse()

  @active: ->
    @_active ||= @crossings.filter (crossing) -> crossing.hasSchedule() && !crossing.isDisabled()

  @realClosest: ->
    @closestTo App.current_position.coords

  @closestTo: (coords) ->
    closest_crossing = null
    closest_distance = Infinity
    for crossing in @crossings when !crossing.isDisabled()
      distance = crossing.distanceFrom(coords.latitude, coords.longitude)
      if distance < closest_distance
        closest_crossing = crossing
        closest_distance = distance
    closest_crossing

  @updateClosest: (coords) ->
    closest = @closestTo(coords)
    if closest != @_closest
      @_closest = @closestTo(coords)
      $(document).trigger('model-updated')

  @init: ->
    @crossings = []

    for train_number in AllegroTime_Data.trains
      new Train(train_number)

    for row in AllegroTime_Data.rows
      [name, dist, lat, lng, closingTimes..., updated_at] = row

      continue if name == 'Санкт-Петербург' || name == 'Выборг'

      crossing = new Crossing(name)
      crossing.distance  = dist
      crossing.latitude  = lat
      crossing.longitude = lng
      crossing.updated_at = updated_at

      for i in [0...AllegroTime_Data.trains.length]
        new Closing closingTimes[i], crossing, AllegroTime_Data.trains[i]

      crossing.sortClosingsByTime()

      @crossings.push crossing

    Closing.all = []
    for crossing in @crossings
      Array.prototype.push.apply(Closing.all, crossing.closings)
