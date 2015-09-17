PREVIOUS_TRAIN_LAG_TIME: 5
CLOSING_TIME: 10

RED_THRESHOLD: 10
YELLOW_THRESHOLD: 30

class @Crossing
  # props: name, latitude, longitude, closings, distance

  # - осталось более часа — зеленый
  # - осталось примерно 55/50/.../20 минут — желтый
  # - осталось примерно 15/10/5 минут — красный
  # - вероятно уже закрыт — красный
  # - Аллегро только что прошел — желтый
  state: ->
    return 'Closed' if @name == 'Поклонногорская'
    return 'Unknown' unless @hasSchedule()

    currentTime = Time.minutes_since_midnight
    trainTime = currentClosing.trainTime
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
  #
  # subtitle: ->
  #   return 'poklonnogorskaya_state'.l if name == 'Поклонногорская'
  #
  #   switch @state()
  #   when 'Clear', 'Soon', 'VerySoon', 'Closing'
  #     minutesTillClosing == 0 ? 'crossing.just_closed'.l : 'crossing.will be closed in X mins'.li(Format.minutes_as_text(minutesTillClosing))
  #   when 'Closed'
  #     minutesTillOpening == 0 ? 'crossing.just_opened'.l : 'crossing.will be opened in X mins'.li(Format.minutes_as_text(minutesTillOpening))
  #   when 'JustOpened'
  #     minutesSinceOpening == 0 ? 'crossing.just_opened'.l : 'crossing.opened X min ago'.li(Format.minutes_as_text(minutesSinceOpening))
  #   when 'Unknown'
  #     "crossing.unknown".l
  #   else
  #     null
  #
  # triggerSubtitleChanged: ->
  #   willChangeValueForKey('subtitle')
  #   didChangeValueForKey('subtitle')

  nextClosing: ->
    currentTime = Time.minutes_since_midnight
    return closing if closing.trainTime >= currentTime for closing in @closings
    return @closings[0]

  previousClosing: ->
    currentTime = Time.minutes_since_midnight

    for closing in @closings.slice(0).reverse()
      return closing if closing.trainTime <= currentTime

    @closings[@closings.length - 1]

  currentClosing: ->
    currentTime = Time.minutes_since_midnight
    nextClosing = @nextClosing()
    previousClosing = @previousClosing()
    if currentTime <= previousClosing.trainTime + PREVIOUS_TRAIN_LAG_TIME && currentTime > previousClosing.trainTime - 1
      previousClosing
    else
      nextClosing;

  minutesTillClosing: ->
    @minutesTillOpening() - CLOSING_TIME

  minutesTillOpening: ->
    trainTime = @nextClosing().trainTime
    currentTime = Time.minutes_since_midnight

    result = trainTime - currentTime
    result = 24 * 60 + result if result < 0
    result

  minutesSinceOpening: ->
    previousTrainTime = @previousClosing().trainTime
    currentTime = Time.minutes_since_midnight

    result = currentTime - previousTrainTime;
    result = 24 * 60 + result if (result < 0)
    result

  isClosest: ->
    this == Model.closestCrossing()


  isCurrent: ->
    this == Model.currentCrossing()

  description: ->
    "<Crossing: #{@name}, #{@latitude}, #{@longitude}, #{@closings.length}>"

  inspect: ->
    @name

  index: ->
    Model.crossings[this]

  toTrackingKey: ->
    @name

  addClosingWithTime: (time, direction:direction) ->
    closing = Closing.new
    closing.crossing = self
    closing.rawTime = time
    closing.trainTime = Device.minutes_from_hhmm(time)
    closing.direction = direction
    closings.addObject closing

  isClosed: ->
    @state == 'Closed'

  isDisabled: ->
    @name == 'Поклонногорская'

  hasSchedule: ->
    @closings.count > 0

  @crossingWithName: (name, latitude:lat, longitude:lng) ->
    crossing = new
    crossing.name = name;
    crossing.latitude = lat;
    crossing.longitude = lng;
    crossing.closings = NSMutableArray.arrayWithCapacity(8)
    crossing

  @getCrossingWithName: (name) ->
    return crossing if crossing.name == name for crossing in Model.crossings()
    console.warn "ERROR #{__method__}: crossing is not found for name = '#{name}'"
    null
