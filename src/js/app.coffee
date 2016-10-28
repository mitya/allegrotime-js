#= require_tree ./lib
#= require_tree ./models
#= require_tree ./components
#= require dispatcher

window.shouldRotateToOrientation = -> true

import { Router, Route, IndexRoute, useRouterHistory, hashHistory } from 'react-router'
import { createHashHistory } from 'history'
import ReactDOM from 'react-dom'

initialEvent = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener initialEvent, ( -> window.app = new Allegro.App; app.start() ), false

window.addEventListener 'load', ->
  # attachFastClick(document.body)
  # document.body.addEventListener 'touchstart', -> true

class Allegro.App
  start: ->
    @state = {}
    @state.minutes = util.minutes_since_midnight(util.current_time())
    @state.log = []

    Allegro.Schedule.load()

    @renderRoutes()
    @bindCallbacks()
    # @bindScreenshots()

  bindCallbacks: ->
    setInterval @timerTicked, 5000
    setInterval @updateTimerTicked, 60 * 60 * 1000
    setTimeout  @checkForUpdates, 500

    $(document).on 'backbutton', @backButtonPressed
    $(document).on 'resign pause', @pause
    $(document).on 'active resume', @resume

    navigator.geolocation?.watchPosition @positionUpdated, @positionWatchFailed, timeout: Infinity, enableHighAccuracy: false

    $('body').addClass(device.platform.toLowerCase()) if window.device

  renderRoutes: ->
    # @history = ReactHistory.createHashHistory(queryKey: false)
    # @history = useRouterHistory(createHashHistory)(queryKey: false)
    # @history = ReactRouter.useRouterHistory(ReactHistory.createHashHistory)(queryKey: false)
    @history = hashHistory
    @router = ReactDOM.render(
      <Router history=@history>
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
    dispatch(MINUTE_CHANGED, minutes: minutes) if minutes != app.state.minutes

  updateTimerTicked: =>
    @checkForUpdates()

  backButtonPressed: =>
    # if ['/about', '/crossings'].some((path) => @router.history.isActive(path))
    #   @router.history.goBack()
    # if app.back
    #   @router.history.push(app.back)

    if @router.history.isActive('/') or @router.history.isActive('/status')
      navigator.app.exitApp()
    else
      @router.history.goBack()

  # usage: app.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  positionUpdated: (position) =>
    dispatch(POSITION_CHANGED, position: position)
    # msg = "#{util.current_time().toLocaleTimeString()}, #{util.format_coords(position.coords)}, #{Allegro.Crossing.closest?.name}"
    # console.debug(msg)

  positionWatchFailed: (error) =>
    console.warn error

  checkForUpdates: (force = false) =>
    Allegro.Schedule.update() if @shouldCheckSchedule() || force

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
    # Allegro.Crossing.setCurrent Allegro.Crossing.get('Удельная')
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
