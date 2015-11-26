class @StatusView
  constructor: ->
    $("#navbar").on 'click', 'li.about', => App.status_nav_controller.push('about')
    $("#navbar").on 'click', 'li.locate', => Crossing.setCurrentToClosest()
    $("#statusbox").on 'click', '#crossing_name', => App.status_nav_controller.push('crossings')

  update: ->
    console.time("update Status")
    crossing = Crossing.current()
    nextClosing = crossing.nextClosing()

    @crossing = crossing

    info =
      crossing: crossing
      crossing_name: crossing.name
      status_class: crossing.color().toLowerCase()
      status_message: crossing.subtitle()
      crossing_status: "Переезд #{crossing.isClosed() && "закрыли" || "закроют"} примерно в #{Helper.minutes_as_hhmm(nextClosing.closingTime())}"
      train_status: "Аллегро пройдет примерно в #{Helper.minutes_as_hhmm(nextClosing.trainTime)}"
      notice: @crossing_message()

    if crossing.name == 'Поклонногорская'
      info.crossing_status = 'Откроют в декабре 2016 (предположительно)'
      info.train_status = ''

    info.alert = AllegroTime_Data.alert if AllegroTime_Data.alert

    Helper.benchmark 'status', =>
      # $('#statusbox .content').html HandlebarsTemplates['status'](info)
      React.render <UI.Status {...info} />, $('#statusbox .content').get(0)

    $('.navbar.for-statusbox li.locate').showIf Crossing.closest() && !Crossing.current().isClosest()

    console.timeEnd("update Status")

  crossing_message: ->
    if @crossing.updated_at
      "Расписание переезда «#{@crossing.name}» обновлено #{@crossing.updated_at}"
    else
      "Расписание переезда «#{@crossing.name}» рассчитано приблизительно, на основе расписания других переездов."
