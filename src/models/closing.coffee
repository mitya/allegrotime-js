import Train from './train'

export default class Closing
  constructor: (@rawTime, @crossing, @trainNumber) ->
    @trainTime = $U.minutesFromHHMM(@rawTime)

  @prop 'closingTime', -> @trainTime - 10
  @prop 'train', -> Train.get(@trainNumber)

  @prop 'toFinland', -> @trainNumber % 2 == 1
  @prop 'toRussia', -> @trainNumber % 2 == 0
  @prop 'isAllegro', -> @trainNumber < 1000
  @prop 'isClosest', -> @ == @crossing.currentClosing
  @prop 'isToday', -> @train.runsOn()
  @prop 'isSV', -> @train.daysComment == 'SV'
  @prop 'isPV', -> @train.daysComment == 'PV'

  @prop 'state', -> @crossing.state
  @prop 'color', -> @crossing.color
  @prop 'directionKey', -> if @toRussia then 'fin' else 'rus'
  @prop 'time', -> $U.minutesAsHHMM @trainTime
  @prop 'timeWithDirectionMark', -> @toRussia && "↶ #{@time}" || @time

  description: -> "Closing(#{@crossing.name}, #{@time}, #{@trainNumber})"
