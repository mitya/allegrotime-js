# props: rawTime, direction, trainTime, crossing
class @Closing
  constructor: (@rawTime, @crossing, @trainNumber) ->
    @trainTime = Helper.minutes_from_hhmm(@rawTime)

  closingTime: ->
    @trainTime - 10

  toFinland: ->
    @trainNumber % 2 == 1

  toRussia: ->
    @trainNumber % 2 == 0

  train: ->
    Train.get(@trainNumber)

  isAllegro: ->
    @trainNumber < 1000

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
