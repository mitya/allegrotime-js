#= require "helper"
#= require "models/crossing"
#= require "models/closing"
#= require "models/model"


document.addEventListener (if window.cordova then "deviceready" else "DOMContentLoaded"), ( -> App.initialize() ), false


class @TabBarController
  constructor: (@tab_controllers) ->
    @current_controller = @tab_controllers[0]
    @tab_scroll_offsets = {}

  open: (tab_controller) ->
    @remember_page_scroll_top()
    @current_controller = tab_controller
    @update_tab_bar(tab_controller)
    tab_controller.show(animated: no)
    @restore_page_scroll_top()

  remember_page_scroll_top: ->
    @tab_scroll_offsets[@current_controller.tab_key] = $('body').scrollTop()

  restore_page_scroll_top: ->
    $('body').scrollTop @tab_scroll_offsets[@current_controller.tab_key]

  update_tab_bar: ->
    $("#tabbar .tab").removeClass('active').filter(".#{@current_controller.tab_key}").addClass('active')


class @NavigationController
  constructor: (root_page_id) ->
    @pages = [root_page_id]
    @tab_key = root_page_id

  push: (page_id) ->
    @pages.push(page_id)
    @update_view()

  pop: ->
    return unless @pages.length > 1
    @pages.pop()
    @update_view()

  update_view: ->
    App.open @current_page_id(), back_button: @pages.length > 1

  show: (options) ->
    App.open @current_page_id(), options

  current_page_id: ->
    @pages[ @pages.length - 1 ]

  @make_back_button: ->
    # $('<span>', class: 'icon back pe-7s-angle-left-circle')
    # $('<img>', class: 'back-button', src: 'images/icons/back.png', height: 20, width: 20)
    $('<img>', class: 'back-button', src: 'images/icons/custom_back.png', height: 20, width: 20)

@App =
  initialize: ->
    window.Model = new ModelManager
    window.Model.init()

    @status_nav_controller = new NavigationController('statusbox')
    @schedule_nav_controller = new NavigationController('schedule')

    @tabbar_controller = new TabBarController([@status_nav_controller, @schedule_nav_controller])
    @tabbar_controller.open(@status_nav_controller)

    @update_ui()

    $(document).on 'model-updated', => @update_ui()
    setInterval ( => @timer_ticked() ), 5000

    @bind()
    @bind_location_monitoring()

  bind: ->
    $("#tabbar li.statusbox").click => @tabbar_controller.open(@status_nav_controller)
    $("#tabbar li.schedule").click => @tabbar_controller.open(@schedule_nav_controller)
    $("#navbar").on 'click', 'li.about', => @status_nav_controller.push('about')
    $("#navbar").on 'click', 'li.back', => @tabbar_controller.current_controller.pop()
    $("#crossing_name").click => @status_nav_controller.push('crossings')
    $("#crossings .tableview").on 'click', 'td', (e) => @change_crossing_to $(e.target).text()
    $("body").on 'touchstart', -> true

  bind_location_monitoring: ->
    if navigator.geolocation
      # navigator.geolocation.getCurrentPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false
      navigator.geolocation.watchPosition @position_updated, @position_watch_failed, timeout: Infinity, enableHighAccuracy: false

  # App.position_updated({coords: {latitude: 60.106213, longitude: 30.154899}})
  position_updated: (position) ->
    @current_position = position
    Model.updateClosestCrossing(position.coords)
    $('#debug-location').text "#{(new Date).toLocaleTimeString()}, #{Helper.format_coords(position.coords)}, #{Model.closestCrossing()?.name}"

  position_watch_failed: (error) ->
    console.log error
    $('#debug-error').text "watch failed: #{error.message}"

  update_ui: ->
    @update_status()
    @update_schedule()

  update_status: ->
    crossing = Model.currentCrossing()
    nextClosing = crossing.nextClosing()

    $('#crossing_name').text(crossing.name)
    $('#status_message').removeClass('green yellow red gray').addClass crossing.color().toLowerCase()
    $('#status_message').text crossing.subtitle()
    $('#crossing_status').text "Переезд #{crossing.isClosed() && "закрыли" || "закроют"} примерно в #{Helper.minutes_as_hhmm(nextClosing.closingTime())}"
    $('#train_status').text "Аллегро пройдет примерно в #{Helper.minutes_as_hhmm(nextClosing.trainTime)}"

    if crossing.name == 'Поклонногорская'
      $('#crossing_status').text 'Откроют — 20.12.2016 (предположительно)'
      $('#train_status').html '&nbsp;'

    if !crossing.hasSchedule()
      $('#crossing_status').html '&nbsp;'
      $('#train_status').html '&nbsp;'


  update_schedule: ->
    crossing = Model.currentCrossing()
    $(".navbar.for-schedule .title span").text(crossing.name)

    closings_rus = crossing.closingsForFromRussiaTrains()
    closings_fin = crossing.closingsForFromFinlandTrains()

    $('#schedule .tableview tbody tr').each (index) ->
      closing_rus = closings_rus[index]
      closing_fin = closings_fin[index]

      render_value = (cell, closing) ->
        cell.text closing.time()
        cell.removeClass('red green yellow gray')
        cell.addClass(closing.color().toLowerCase()) if closing.isClosest()

      render_value $('th.rus', this), closing_rus
      render_value $('th.fin', this), closing_fin

  open: (page_id, {animated, back_button} = {}) ->
    animated ?= true
    duration = if animated then 150 else 0

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
          tableview = $('#crossings .tableview')
          unless $('tr', tableview).length
            for crossing in Model.crossings
              row = $('<tr>', 'data-key': crossing.name, class: "touchable")
              row.append $('<td>', class: 'image', html: $('<div>', class: "statusrow #{crossing.color().toLowerCase()}"))
              row.append $('<td>', class: 'text').text(crossing.name)
              tableview.append(row)
          tableview.find('tr td.checkmark').removeClass('checkmark')
          selected_row = tableview.find('tr').filter( -> this.dataset.key == Model.currentCrossing().name)
          selected_row.find('td.text').addClass('checkmark')

      $.when( navbar.fadeIn(duration), page.fadeIn(duration) ).done =>
        if page_id == 'crossings'
          $('body').animate scrollTop: selected_row.position().top - 200, 150 if animated

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
    current_minute = new Date().getMinutes()
    if current_minute != @last_update_minute
      @last_update_minute = current_minute
      @update_ui()

  change_crossing_to: (crossing_name) ->
    Model.setCurrentCrossing Crossing.get(crossing_name)
    @status_nav_controller.pop()
