class @Train
  constructor: (@number) ->
    @direction = if @number % 2 == 0 then 'FIN' else 'RUS'

  runsOn: (day = util.current_time().getDay()) ->
    switch @daysComment()
      when 'SV' then day == 6 or day == 0
      when 'PV' then day == 5 or day == 0
      else true

  daysComment: ->
    switch @number
      when 7203, 7210 then 'SV'
      when 7209 then 'PV'
      else null

    # switch @number
    #   when 7203, 7206 then 'SV'
    #   when 7209, 7210 then 'PV'
    #   else null

  @get: (number) -> ds.trains[number]
  @count: -> _.size(ds.trains)
