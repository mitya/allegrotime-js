#= require "helper"
#= require "models/crossing"
#= require "models/closing"
#= require "models/model"

$ ->
  $("#tabbar li.schedule").click -> App.open('schedule')
  $("#tabbar li.status").click -> App.open('statusbox')
  $("#navbar").on 'click', 'li.about', -> App.open('about')

  window.Model = new ModelManager
  window.Model.init()

  App.update_ui()

  $(document).on 'model-updated', -> App.update_ui()

  App.open('statusbox')

@App =
  update_ui: ->
    @update_status()
    @update_schedule()

  update_status: ->
    crossing = Model.currentCrossing()
    nextClosing = crossing.nextClosing()

    $('#navbar .title').text(crossing.name)
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
    $('#schedule .tableview tr').each (index) ->
      closing = crossing.closings[index]
      $('th', this).text closing.time()

  open: (page_id) ->
    console.log "opening #{page_id}"

    if current_page = $('#container .page')[0]
      holder = $("#pages ##{current_page.id}-holder")
      holder.html(current_page)
      $('#navbar ul.navbar').prependTo(current_page)

    page = $("#pages ##{page_id}")
    navbar = page.find('.navbar')
    $('#navbar').html(navbar)
    $('#container').html(page)
