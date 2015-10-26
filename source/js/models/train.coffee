class @Train
  constructor: (@number) ->
    @direction = if @number % 2 == 0 then 'FIN' else 'RUS'
    Train.all[@number] = this

  runsOn: (day = (new Date).getDay()) ->
    switch @number
      when 7203, 7206
        day == 6 or day == 0
      when 7209, 7210
        day == 5 or day == 0
      else
        yes

  @all: {}
  @get: (number) ->
    @all[number]

