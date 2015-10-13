class @Closing
  # props: rawTime, direction, trainTime, crossing

  constructor: (@rawTime, @direction, @crossing, @number) ->
    @crossing.closings.push this if @crossing
    @trainTime = Helper.minutes_from_hhmm(@rawTime)
    @trainTime += 60 if Crossing::WINTER_TIME && @direction == 'FIN' && @number in [1,5]

  closingTime: ->
    @trainTime - 10

  toRussia: ->
    @direction == 'FIN'

  trainNumber: ->
    position = @crossing.closings.indexOf(this)
    780 + 1 + position

  isAllegro: ->
    @direction == 'FIN' && @number % 2 == 1 || @direction == 'RUS' && @number % 2 == 0

  directionCode: ->
    @direction || "N/A"

  description: ->
    "Closing(#{@crossing.name}, #{@time()}, #{@directionCode()})"

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
