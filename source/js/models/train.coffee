class @Train
  constructor: (@number) ->
    @direction = if @number % 2 == 0 then 'FIN' else 'RUS'

  runsOn: (day = Helper.current_time().getDay()) ->
    switch @number
      when 7203, 7206 then day == 6 or day == 0
      when 7209, 7210 then day == 5 or day == 0
      else true

  daysComment: ->
    switch @number
      when 7203, 7206 then 'SV'
      when 7209, 7210 then 'PV'
      else null

  @index: {}
  @get: (number) ->
    @index[number]

