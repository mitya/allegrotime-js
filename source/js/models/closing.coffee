class @Closing
  constructor: (@rawTime, @crossing, @trainNumber) ->
    @trainTime = util.minutes_from_hhmm(@rawTime)

  closingTime: -> @trainTime - 10
  train: -> Train.get(@trainNumber)

  toFinland: -> @trainNumber % 2 == 1
  toRussia: -> @trainNumber % 2 == 0
  isAllegro: -> @trainNumber < 1000
  isClosest: -> @ == @crossing.currentClosing()
  isToday: -> @train().runsOn()
  isSV: -> @train().daysComment() == 'SV'
  isPV: -> @train().daysComment() == 'PV'

  description: -> "Closing(#{@crossing.name}, #{@time()}, #{@trainNumber})"
  state: -> @crossing.state
  color: -> @crossing.color()
  directionKey: -> if @toRussia() then 'fin' else 'rus'
  time: -> util.minutes_as_hhmm @trainTime
  timeWithDirectionMark: -> @toRussia() && "↶ #{@time()}" || @time()
