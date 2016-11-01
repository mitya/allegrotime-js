export default class Train
  constructor: (@number) ->
    @direction = if @number % 2 == 0 then 'FIN' else 'RUS'

  runsOn: (day = $U.now().getDay()) ->
    switch @daysComment
      when 'SV' then day == 6 or day == 0
      when 'PV' then day == 5 or day == 0
      else true

  @prop 'daysComment', -> appState.schedule.train_rules[@number]

  @get: (number) -> appState.trains[number]
  @count: -> _.size(appState.trains)
