class @StatusView
  constructor: ->
    $("#navbar").on 'click', 'li.about', => App.status_nav_controller.push('about')
    $("#navbar").on 'click', 'li.locate', => Crossing.setCurrentToClosest()
    # $("#crossing_name").click => App.status_nav_controller.push('crossings')
    $("#statusbox").click '#crossing_name', => App.status_nav_controller.push('crossings')

  update: ->
    crossing = Crossing.current()
    nextClosing = crossing.nextClosing()

    @crossing = crossing

    info =
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
    $('#statusbox .content').html HandlebarsTemplates['status'](info)


    # $('#crossing_name').text(crossing.name)
    # $('#status_message').removeClass('green yellow red gray').addClass crossing.color().toLowerCase()
    # $('#status_message').text crossing.subtitle()
    # $('#crossing_status').text "Переезд #{crossing.isClosed() && "закрыли" || "закроют"} примерно в #{Helper.minutes_as_hhmm(nextClosing.closingTime())}"
    # $('#train_status').text "Аллегро пройдет примерно в #{Helper.minutes_as_hhmm(nextClosing.trainTime)}"
    # $('#statusbox .status-notice').text @crossing_message()
    #
    # if crossing.name == 'Поклонногорская'
    #   $('#crossing_status').text 'Откроют в декабре 2016 (предположительно)'
    #   $('#train_status').html '&nbsp;'
    #
    # if !crossing.hasSchedule()
    #   $('#crossing_status').html '&nbsp;'
    #   $('#train_status').html '&nbsp;'
    #
    # if AllegroTime_Data.alert
    #   $('#statusbox .status-alert').text AllegroTime_Data.alert

    $('.navbar.for-statusbox li.locate').showIf Crossing.closest() && !Crossing.current().isClosest()

  crossing_message: ->
    if @crossing.updated_at
      "Расписание переезда «#{@crossing.name}» обновлено #{@crossing.updated_at}"
    else
      "Расписание переезда «#{@crossing.name}» рассчитано приблизительно, на основе расписания других переездов."
