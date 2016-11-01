import {setupRoutes, getHistory} from './routes'

export default class AppState
  constructor: ->
    @state = {}
    @state.minutes = util.minutes_since_midnight util.current_time()
    @state.log = []

  # checkForUpdates: (force = false) =>
  #   Schedule.update() if @shouldCheckSchedule() || force
  #
  # shouldCheckSchedule: ->
  #   return true if !localStorage.checked_for_updates_at
  #   new Date - new Date(localStorage.checked_for_updates_at) > 1000*60*60*24*1
