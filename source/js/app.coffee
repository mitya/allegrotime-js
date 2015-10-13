#= require "helper"
#= require "widgets"
#= require "views/status"
#= require "views/schedule"
#= require "views/crossings"
#= require "models/crossing"
#= require "models/closing"

document.addEventListener (if window.cordova then "deviceready" else "DOMContentLoaded"), ( -> App.initialize() ), false

@App =
  initialize: ->
    Crossing.init()

    @status_nav_controller = new NavigationController('statusbox')
    @schedule_nav_controller = new NavigationController('schedule')
    @tabbar_controller = new TabBarController([@status_nav_controller, @schedule_nav_controller])
    @status_view = new StatusView
    @schedule_view = new ScheduleView
    @crossings_view = new CrossingsView

    FastClick.attach(document.body)
    @bind()
    @bind_location_monitoring()

    $(document).on 'model-updated', => @update_ui()
    setInterval ( => @timer_ticked() ), 5000

    setInterval ( => @update_timer_ticked() ), 60 * 60 * 1000

    $(document).on 'resign', => @pause()
    $(document).on 'active', => @resume()

    @update_ui()

  bind: ->
    $("#tabbar li.statusbox").click => @tabbar_controller.open(@status_nav_controller)
    $("#tabbar li.schedule").click => @tabbar_controller.open(@schedule_nav_controller)
    $("#navbar").on 'click', 'li.back', => @tabbar_controller.current_controller.pop()
    $("body").on 'touchstart', -> true

  bind_location_monitoring: ->
    if navigator.geolocation
      navigator.geolocation.watchPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false

  # App.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  position_updated: (position) ->
    @current_position = position
    Crossing.updateClosest(position.coords)
    $('#debug-location').text "#{(new Date).toLocaleTimeString()}, #{Helper.format_coords(position.coords)}, #{Crossing.closest()?.name}"

  position_watch_failed: (error) ->
    console.log error
    $('#debug-error').text "watch failed: #{error.message}"

  update_ui: ->
    @status_view.update()
    @schedule_view.update()

  pause: ->
    @paused = true
    $('#status_message').removeClass('green yellow red').addClass('gray')

  resume: ->
    @paused = false
    @update_ui()

  open: (page_id, {animated, back_button} = {}) ->
    animated ?= true
    duration = if animated then 0 else 0

    console.log "opening #{page_id}, animated=#{animated}"

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
        when 'crossings'
          @crossings_view.before_show()

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
    current_minute = new Date().getMinutes()
    if current_minute != @last_update_minute
      @last_update_minute = current_minute
      @update_ui()

  update_timer_ticked: ->
    $('#debug-info').text "schedule updated at #{(new Date).toLocaleTimeString()}"
