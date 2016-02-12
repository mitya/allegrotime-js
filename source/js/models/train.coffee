class window.Train
  constructor: (@number) ->
    @direction = if @number % 2 == 0 then 'FIN' else 'RUS'

  runsOn: (day = util.current_time().getDay()) ->
    switch @daysComment
      when 'SV' then day == 6 or day == 0
      when 'PV' then day == 5 or day == 0
      else true

  @prop 'daysComment', -> ds.schedule.train_rules[@number]

  @get: (number) -> ds.trains[number]
  @count: -> _.size(ds.trains)
