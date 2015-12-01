#= require_tree ./lib
#= require_tree ./models
#= require_tree ./components

document.addEventListener (if window.cordova then "deviceready" else "DOMContentLoaded"), ( -> App.initialize() ), false
window.shouldRotateToOrientation = -> true

window.cordova = { no: yes } unless window.cordova

@App =
  initialize: ->
    Schedule.load()

    FastClick.attach(document.body)
    @bind()
    @bind_location_monitoring()

    setInterval ( => @timer_ticked() ), 5000
    setInterval ( => @update_timer_ticked() ), 60 * 60 * 1000

    $(document).on 'model-updated', => @update_ui()
    $(document).on 'resign pause', => @pause()
    $(document).on 'active resume', => @resume()

    @update_ui()
    @check_for_updates()

    $('body').addClass("#{device.platform.toLowerCase()}") if window.device

    render(
      <Router>
        <Route path="/" component={CLayout}>
          <IndexRoute component={CStatus}/>
          <Route path="about" component={CAbout}/>
          <Route path="status" component={CStatus}/>
          <Route path="crossings" component={CCrossings}/>
          <Route path="schedule" component={CSchedule}/>
        </Route>
      </Router>
      $e('container')
    )

  bind: ->
    $(document).on 'backbutton', =>
      if $("#navbar li.back").length
        @tabbar_controller.current_controller.pop()
      else
        navigator.app.exitApp()

    $("body").on 'touchstart', -> true

    # @bind_screenshots() # uncomment to take screen shots

  bind_location_monitoring: ->
    if navigator.geolocation
      navigator.geolocation.watchPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false

  bind_screenshots: ->
    Crossing.setCurrent Crossing.get('Удельная')
    @actions = [
      ( => @tabbar_controller.open(@schedule_nav_controller) ),
      ( => @tabbar_controller.open(@status_nav_controller) ),
      ( => App.status_nav_controller.push('crossings') )
    ]
    $("body").on 'click', =>
      action = @actions.shift()
      action.call()

  # uasge: app.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  position_updated: (position) ->
    @current_position = position
    Crossing.updateClosest(position.coords)
    # $('#debug-location').text "#{Helper.current_time().toLocaleTimeString()}, #{Helper.format_coords(position.coords)}, #{Crossing.closest()?.name}"

  position_watch_failed: (error) ->
    console.log error

  update_ui: ->

  pause: ->
    @paused = true
    $('#status_message').removeClass('green yellow red').addClass('gray')

  resume: ->
    @paused = false
    @update_ui()

  timer_ticked: ->
    return if @paused
    current_minute = Helper.current_time().getMinutes()
    if current_minute != @last_update_minute
      @last_update_minute = current_minute
      @update_ui()

  update_timer_ticked: ->
    @check_for_updates()

  check_for_updates: (force = false) ->
    if @should_check_schedule() || force
      localStorage.checked_for_updates_at = new Date
      $.get @schedule_timestamp_url, (response) =>
        if response.updated_at > Schedule.current.updated_at
          $.get @schedule_url, (schedule) =>
            if schedule.updated_at > Schedule.current.updated_at
              localStorage.schedule = JSON.stringify(schedule)
              Schedule.load()
              @update_ui()

  should_check_schedule: ->
    return true if !localStorage.checked_for_updates_at
    new Date - new Date(localStorage.checked_for_updates_at) > 1000*60*60*24*1

  schedule_timestamp_url: "https://allegrotime.firebaseapp.com/data/schedule_timestamp.json"
  schedule_url: "https://allegrotime.firebaseapp.com/data/schedule.json"

@app = @App
