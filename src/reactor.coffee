export default class Reactor
  start: ->
    setInterval @secondTicked, 5000
    setInterval @hourTicked, 60 * 60 * 1000
    setTimeout  @checkForUpdates, 500

    $(document).on 'backbutton', @backPressed
    $(document).on 'resign pause', @pause
    $(document).on 'active resume', @resume

    navigator.geolocation?.watchPosition @positionUpdated, @positionWatchFailed,
      timeout: Infinity, enableHighAccuracy: false

  secondTicked: =>
    return if @paused
    minutes = util.minutes_since_midnight util.current_time()
    dispatch MINUTE_CHANGED, minutes: minutes if minutes != app.state.minutes

  hourTicked: =>
    # dispatch CHECK_SCHEDULE_UPDATES_IF_NEEDED
    # @checkForUpdates()

  backPressed: =>
    if @history.isActive('/') or @history.isActive('/status')
      navigator.app.exitApp()
    else
      @history.goBack()

  positionUpdated: (position) =>
    dispatch POSITION_CHANGED, position: position

  positionWatchFailed: (error) =>
    console.warn error

  pause: =>
    @paused = true
    $('body').addClass('disabled')

  resume: =>
    @paused = false
    $('body').removeClass('disabled')
    dispatch APP_AWAKED
    # util.trigger(MODEL_UPDATED, 'app.resume')




  checkForUpdates: (force = false) =>
    Schedule.update() if @shouldCheckSchedule() || force

  shouldCheckSchedule: ->
    return true if !localStorage.checked_for_updates_at
    new Date - new Date(localStorage.checked_for_updates_at) > 1000*60*60*24*1
