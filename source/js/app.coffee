#= require_tree ./lib
#= require_tree ./models
#= require_tree ./components
#= require dispatcher

document.addEventListener (if window.cordova then "deviceready" else "DOMContentLoaded"), ( -> window.app = new App; app.start() ), false

window.shouldRotateToOrientation = -> true
window.cordova = { no: yes } unless window.cordova
window.ds = {}

{Router, Route, IndexRoute} = ReactRouter

class App
  start: ->
    Schedule.load()
    ds.minutes = util.minutes_since_midnight(util.current_time())

    @bindCallbacks()
    # @bindScreenshots()
    @renderRoutes()

  bindCallbacks: ->
    setInterval @timerTicked, 5000
    setInterval @updateTimerTicked, 60 * 60 * 1000
    setTimeout @checkForUpdates, 500

    FastClick.attach(document.body)
    $(document).on 'backbutton', @backButtonPressed
    $(document).on 'resign pause', @pause
    $(document).on 'active resume', @resume

    navigator.geolocation?.watchPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false

    $('body').addClass(device.platform.toLowerCase()) if window.device

  renderRoutes: ->
    ReactDOM.render(
      <Router>
        <Route path="/" component={CLayout}>
          <IndexRoute component={CStatus}/>
          <Route path="about" component={CAbout}/>
          <Route path="status" component={CStatus}/>
          <Route path="crossings" component={CCrossings}/>
          <Route path="schedule" component={CSchedule}/>
        </Route>
      </Router>
      $e('application')
    )

  timerTicked: =>
    return if @paused
    time = util.current_time()
    minutes = util.minutes_since_midnight(time)
    dispatch(MINUTE_CHANGED, minutes: minutes) if minutes != ds.minutes

  updateTimerTicked: =>
    @checkForUpdates()

  backButtonPressed: =>
    # FIX back button
    if $("#navbar li.back").length
      @tabbar_controller.current_controller.pop()
    else
      navigator.app.exitApp()

  # usage: app.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  position_updated: (position) =>
    dispatch(POSITION_CHANGED, position: position)
    # msg = "#{util.current_time().toLocaleTimeString()}, #{util.format_coords(position.coords)}, #{Crossing.closest()?.name}"
    # console.debug(msg)

  position_watch_failed: (error) =>
    console.warn error

  checkForUpdates: (force = false) =>
    Schedule.update() if @shouldCheckSchedule() || force

  shouldCheckSchedule: ->
    return true if !localStorage.checked_for_updates_at
    new Date - new Date(localStorage.checked_for_updates_at) > 1000*60*60*24*1

  pause: ->
    @paused = true
    $('body').addClass('disabled')

  resume: ->
    @paused = false
    $('body').removeClass('disabled')
    util.trigger(MODEL_UPDATED, 'app.resume')

  bindScreenshots: ->
    # FIX screenshots
    # Crossing.setCurrent Crossing.get('Удельная')
    # @actions = [
    #   ( => @tabbar_controller.open(@schedule_nav_controller) ),
    #   ( => @tabbar_controller.open(@status_nav_controller) ),
    #   ( => app.status_nav_controller.push('crossings') )
    # ]
    #
    # # @actions = [
    # #   ( => dispatch openTab('schedule') ),
    # #   ( => history.pushState('/schedule') ),
    # #   ( => dispatch openTab('status') )
    # # ]
    #
    # $("body").on 'click', =>
    #   action = @actions.shift()
    #   action.call()
