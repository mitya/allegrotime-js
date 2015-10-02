class @Closing
  # props: rawTime, direction, trainTime, crossing

  constructor: (@rawTime, @direction, @crossing) ->
    @crossing.closings.push this if @crossing
    @trainTime = Helper.minutes_from_hhmm(@rawTime)

  closingTime: ->
    @trainTime - 10

  toRussia: ->
    @direction == 'FIN'

  trainNumber: ->
    position = @crossing.closings.indexOf(this)
    780 + 1 + position

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
