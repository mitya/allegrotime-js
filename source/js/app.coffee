#= require "lib/extensions"
#= require "lib/helper"
#= require "lib/navigation_controller"
#= require "lib/tab_bar_controller"
#= require "views/status"
#= require "views/schedule"
#= require "views/crossings"
#= require "views/about"
#= require "models/train"
#= require "models/crossing"
#= require "models/closing"
#= require "models/schedule"

document.addEventListener (if window.cordova then "deviceready" else "DOMContentLoaded"), ( -> App.initialize() ), false
# window.shouldRotateToOrientation = -> true

window.cordova = { no: yes } unless window.cordova

@App =
  initialize: ->
    Schedule.load()

    @status_nav_controller = new NavigationController('statusbox')
    @schedule_nav_controller = new NavigationController('schedule')
    @tabbar_controller = new TabBarController([@status_nav_controller, @schedule_nav_controller], 0)
    @status_view = new StatusView
    @schedule_view = new ScheduleView
    @crossings_view = new CrossingsView
    @about_view = new AboutView

    FastClick.attach(document.body)
    @bind()
    @bind_location_monitoring()

    $(document).on 'model-updated', => @update_ui()
    setInterval ( => @timer_ticked() ), 5000

    setInterval ( => @update_timer_ticked() ), 60 * 60 * 1000

    $(document).on 'resign pause', => @pause()
    $(document).on 'active resume', => @resume()

    @update_ui()
    @check_for_updates()

    if window.device
      $('body').addClass("#{device.platform.toLowerCase()}")

  bind: ->
    $("#tabbar li.statusbox").click => @tabbar_controller.open(@status_nav_controller)
    $("#tabbar li.schedule").click => @tabbar_controller.open(@schedule_nav_controller)
    $("#navbar").on 'click', 'li.back', => @tabbar_controller.current_controller.pop()
    $(document).on 'backbutton', =>
      if $("#navbar li.back").length
        @tabbar_controller.current_controller.pop()
      else
        navigator.app.exitApp()

    $("body").on 'touchstart', -> true

    # Crossing.setCurrent Crossing.get('Удельная')
    # @actions = [
    #   ( => @tabbar_controller.open(@schedule_nav_controller) ),
    #   ( => @tabbar_controller.open(@status_nav_controller) ),
    #   ( => App.status_nav_controller.push('crossings') )
    # ]
    # $("body").on 'click', =>
    #   action = @actions.shift()
    #   action.call()

  bind_location_monitoring: ->
    if navigator.geolocation
      navigator.geolocation.watchPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false

  # App.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  position_updated: (position) ->
    @current_position = position
    Crossing.updateClosest(position.coords)
    $('#debug-location').text "#{Helper.current_time().toLocaleTimeString()}, #{Helper.format_coords(position.coords)}, #{Crossing.closest()?.name}"

  position_watch_failed: (error) ->
    console.log error
    $('#debug-error').text "watch failed: #{error.message}"

  update_ui: ->
    @status_view.update()
    @schedule_view.update()
    @crossings_view.update()

  pause: ->
    @paused = true
    $('#status_message').removeClass('green yellow red').addClass('gray')

  resume: ->
    @paused = false
    @update_ui()

  open: (page_id, {animated, back_button} = {}) ->
    animated ?= true
    duration = if animated then 0 else 0

    # console.log "opening #{page_id}, animated=#{animated}"

    show_new_page = =>
      page = $("#pages ##{page_id}")
      page.hide()
      page.appendTo('#container')

      navbar = page.find(".navbar")
      navbar.hide()
      $('#navbar').html(navbar)

      if back_button == true
        $("#navbar .left").addClass("back").html NavigationController.make_back_button()
      if back_button == false
        $("#navbar .left").removeClass("back").find('.back-button').remove()

      switch page_id
        when 'crossings' then @crossings_view.before_show()
        when 'about' then @about_view.before_show()

      $.when( navbar.fadeIn(duration), page.fadeIn(duration) ).done =>
        if page_id == 'crossings'
          @crossings_view.after_show(animated)

    if $('#container .page').length
      current_page = $('#container .page')
      current_navbar = $('#navbar ul.navbar')
      page_holder = $("#pages ##{current_page.attr('id')}-holder")
      $.when( current_navbar.fadeOut(duration), current_page.fadeOut(duration) ).done =>
        current_navbar.hide().prependTo(current_page)
        current_page.appendTo(page_holder)
        show_new_page()
    else
      show_new_page()

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
