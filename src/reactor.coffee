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
    minutes = $U.minutesSinceMidnight $U.now()
    app.dispatch MINUTE_CHANGED, minutes: minutes if minutes != appState.minutes

  hourTicked: =>
    app.dispatch CHECK_SCHEDULE_UPDATES_IF_NEEDED
    @checkForUpdates()

  backPressed: =>
    if @history.isActive('/') or @history.isActive('/status')
      navigator.app.exitApp()
    else
      @history.goBack()

  positionUpdated: (position) =>
    app.dispatch POSITION_CHANGED, position: position

  positionWatchFailed: (error) =>
    console.warn error

  pause: =>
    @paused = true
    $('body').addClass('disabled')

  resume: =>
    @paused = false
    $('body').removeClass('disabled')
    app.dispatch APP_AWAKED
