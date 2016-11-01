import Closing from './closing'
import Crossing from './crossing'
import Train from './train'

SCHEDULE_TIMESTAMP_URL = "https://allegrotime.firebaseapp.com/data/schedule_timestamp.json"
SCHEDULE_URL = "https://allegrotime.firebaseapp.com/data/schedule_v2.json"

export default class Schedule
  constructor: (data) ->
    @[key] = value for key, value of data

  init: ->
    appState.trains = {}
    appState.crossings = []

    for train_number in @trains
      appState.trains[train_number] = new Train(train_number)

    for crossingData in @crossings
      continue if crossingData.name == 'Санкт-Петербург' || crossingData.name == 'Выборг'

      crossing = new Crossing(crossingData.name, crossingData.distance, crossingData.lat, crossingData.lng, crossingData.updated_at)

      for closingTime, i in crossingData.closings
        crossing.closings.push new Closing(closingTime, crossing, @trains[i])
      crossing.sortClosingsByTime()

      appState.crossings.push crossing

    app.trigger(MODEL_UPDATED, 'schedule.init')

  valid: ->
    @trains &&
    @updated_at &&
    @crossings &&
    @crossings.length > 20 &&
    @crossings[0].closings &&
    @crossings[0].closings.length > 10

  @load: ->
    schedule = AllegroTime_Data
    if localStorage.schedule
      try
        local_schedule = new this(JSON.parse localStorage.schedule)
        if local_schedule.valid()
          if local_schedule.updated_at > schedule.updated_at
            schedule = local_schedule
      catch error
        console.error "JSON parsing error:", error
        localStorage.schedule = null

    appState.schedule = new this(schedule)
    appState.schedule.init()

  @update: ->
    localStorage.checked_for_updates_at = new Date
    $.get SCHEDULE_TIMESTAMP_URL, (response) =>
      if response.updated_at > appState.schedule.updated_at
        $.get SCHEDULE_URL, (schedule) =>
          if schedule.updated_at > appState.schedule.updated_at
            localStorage.schedule = JSON.stringify(schedule)
            @load()

  updateIfNeeded: =>
    @update() if @shouldUpdate()

  @shouldUpdate: ->
    return true if !localStorage.checked_for_updates_at
    new Date - new Date(localStorage.checked_for_updates_at) > 1000*60*60*24*1
