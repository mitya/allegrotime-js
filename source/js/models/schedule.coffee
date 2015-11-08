class @Schedule
  constructor: (data) ->
    for key, value of data
      this[key] = value

  init: ->
    Train.index = {}
    Crossing.all = []
    Closing.all = []

    for train_number in @trains
      Train.index[train_number] = new Train(train_number)

    for row in @rows
      [name, dist, lat, lng, closingTimes..., updated_at] = row

      continue if name == 'Санкт-Петербург' || name == 'Выборг'

      crossing = new Crossing(name, dist, lat, lng, updated_at)

      for i in [0...@trains.length]
        crossing.closings.push new Closing closingTimes[i], crossing, @trains[i]

      crossing.sortClosingsByTime()
      Crossing.all.push crossing

    for crossing in Crossing.all
      Array.prototype.push.apply(Closing.all, crossing.closings)

  valid: ->
    @trains &&
    @updated_at &&
    @rows &&
    @rows.length > 20 &&
    @rows[0].length > 10

  @load: ->
    schedule = AllegroTime_Data
    if localStorage.schedule
      local_schedule = new Schedule JSON.parse(localStorage.schedule)
      if local_schedule.valid()
        if local_schedule.updated_at > schedule.updated_at
          schedule = local_schedule

    Schedule.current = new Schedule(schedule)
    Schedule.current.init()

  @current: null
