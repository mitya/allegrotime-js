SCHEDULE_TIMESTAMP_URL = "https://allegrotime.firebaseapp.com/data/schedule_timestamp.json"
SCHEDULE_URL = "https://allegrotime.firebaseapp.com/data/schedule.json"

class @Schedule
  constructor: (data) ->
    @[key] = value for key, value of data

  init: ->
    ds.trains = {}
    ds.crossings = []

    for train_number in @trains
      ds.trains[train_number] = new Train(train_number)

    for row in @rows
      [name, dist, lat, lng, closingTimes..., updated_at] = row
      continue if name == 'Санкт-Петербург' || name == 'Выборг'

      crossing = new Crossing(name, dist, lat, lng, updated_at)
      for i in [0...@trains.length]
        crossing.closings.push new Closing closingTimes[i], crossing, @trains[i]

      crossing.sortClosingsByTime()
      ds.crossings.push crossing

    util.trigger(MODEL_UPDATED, 'schedule.init')

  valid: ->
    @trains &&
    @updated_at &&
    @rows &&
    @rows.length > 20 &&
    @rows[0].length > 10

  @load: ->
    schedule = AllegroTime_Data
    if localStorage.schedule
      try
        local_schedule = new Schedule JSON.parse(localStorage.schedule)
        if local_schedule.valid()
          if local_schedule.updated_at > schedule.updated_at
            schedule = local_schedule
      catch error
        console.error "JSON parsing error:", error
        localStorage.schedule = null

    ds.schedule = new Schedule(schedule)
    ds.schedule.init()

  @update: ->
    localStorage.checked_for_updates_at = new Date
    $.get SCHEDULE_TIMESTAMP_URL, (response) =>
      if response.updated_at > ds.schedule.updated_at
        $.get SCHEDULE_URL, (schedule) =>
          if schedule.updated_at > ds.schedule.updated_at
            localStorage.schedule = JSON.stringify(schedule)
            Schedule.load()
