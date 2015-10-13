class @ScheduleView
  update: ->
    crossing = Model.currentCrossing()
    $(".navbar.for-schedule .title span").text(crossing.name)

    closings_rus = crossing.closingsForFromRussiaTrains()
    closings_fin = crossing.closingsForFromFinlandTrains()

    $('#schedule .tableview tbody tr').each (index) ->
      closing_rus = closings_rus[index]
      closing_fin = closings_fin[index]

      render_value = (cell, closing) ->
        cell.text closing.time()
        cell.removeClass('red green yellow gray allegro')
        cell.addClass('allegro') if closing.isAllegro()
        cell.addClass(closing.color().toLowerCase()) if closing.isClosest()

      render_value $('th.rus', this), closing_rus
      render_value $('th.fin', this), closing_fin
