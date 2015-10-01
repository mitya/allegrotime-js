#= require "helper"
#= require "models/crossing"
#= require "models/closing"
#= require "models/model"

$ ->
  $("#tabbar li.schedule").click -> App.open_tab('schedule')
  $("#tabbar li.statusbox").click -> App.open_tab('statusbox')
  $("#navbar").on 'click', 'li.about', -> App.open('about')
  $("#crossing_name").click -> App.open('crossings')
  $("#crossings .tableview").on 'click', 'td', -> App.change_crossing_to $(this).text()
  $("body").on 'touchstart', -> true

  window.Model = new ModelManager
  window.Model.init()

  App.update_ui()

  $(document).on 'model-updated', -> App.update_ui()

  App.open_tab('statusbox')

  setInterval ( -> App.timer_ticked() ), 5000

@App =
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
    $(".navbar.for-schedule .title").text(crossing.name)
    $('#schedule .tableview tr').each (index) ->
      closing = crossing.closings[index]
      $('th', this).text closing.time()
      $(this).removeClass('red green yellow gray')
      if closing.isClosest()
        $(this).addClass(closing.color().toLowerCase())

  open: (page_id) ->
    console.log "opening #{page_id}"

    if current_page = $('#container .page')[0]
      holder = $("#pages ##{current_page.id}-holder")
      holder.html(current_page)
      $('#navbar ul.navbar').prependTo(current_page)

    page = $("#pages ##{page_id}")
    navbar = page.find(".navbar")
    $('#navbar').html(navbar)
    $('#container').html(page)

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
        selected_row = tableview.find('tr').filter( -> console.log this; this.dataset.key == Model.currentCrossing().name)
        selected_row.find('td.text').addClass('checkmark')

  timer_ticked: ->
    current_minute = new Date().getMinutes()
    if current_minute != @last_update_minute
      @last_update_minute = current_minute
      @update_ui()

  change_crossing_to: (crossing_name) ->
    Model.setCurrentCrossing Crossing.get(crossing_name)
    @open 'statusbox'

  open_tab: (tab_key) ->
    $("#tabbar .tab").removeClass('active').filter(".#{tab_key}").addClass('active')
    @open(tab_key)
