class @Closing
  # props: rawTime, direction, trainTime, crossing

  constructor: (@rawTime, @crossing, @trainNumber) ->
    @trainTime = Helper.minutes_from_hhmm(@rawTime)
    # @direction = Train.get(@trainNumber).direction
    # @trainTime += 60 if Crossing::WINTER_TIME && @direction == 'FIN' && @number in [1,5]

  closingTime: ->
    @trainTime - 10

  toFinland: ->
    @trainNumber % 2 == 1

  toRussia: ->
    @trainNumber % 2 == 0

  train: ->
    Train.get(@trainNumber)

  # trainNumber: ->
  #   position = @crossing.closings.indexOf(this)
  #   780 + 1 + position

  isAllegro: ->
    @trainNumber < 1000
    # @direction == 'FIN' && @number % 2 == 1 || @direction == 'RUS' && @number % 2 == 0

  # directionCode: ->
  #   @direction || "N/A"

  description: ->
    "Closing(#{@crossing.name}, #{@time()}, #{@trainNumber})"

  state: ->
    @crossing.state

  isClosest: ->
    this == @crossing.currentClosing()

  color: ->
    @crossing.color()

  toTrackingKey: ->
    "#{@crossing.name}-#{@time}"

  time: ->
    Helper.minutes_as_hhmm @trainTime

  timeWithDirectionMark: ->
    @toRussia() && "↶ #{@time()}" || @time()

  @WINTER_TIME: Date.now() >= new Date('2015-10-25') && Date.now() < new Date('2016-03-26')


class @ClosingInfo
  constructor: (@closing) ->
    @time = @closing.time()
    @trainNumber = @closing.trainNumber
    @isAllegro = @closing.isAllegro()
    @runsToday = @closing.train().runsOn()
    @isSV = @closing.train().daysComment() == 'SV'
    @isPV = @closing.train().daysComment() == 'PV'
    @directionKey = @closing.toRussia() && 'fin' || 'rus'

    @css = []
    @css.push "allegro" if @isAllegro
    @css.push "sv" if @isSV
    @css.push "pv" if @isPV
    @css.push "disabled" if !@runsToday
    @css.push @closing.color().toLowerCase() if @closing.isClosest()
    @css = @css.join(" ")
