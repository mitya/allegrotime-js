class @StatusView
  constructor: ->
    $("#navbar").on 'click', 'li.about', => App.status_nav_controller.push('about')
    $("#crossing_name").click => App.status_nav_controller.push('crossings')

  update: ->
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
