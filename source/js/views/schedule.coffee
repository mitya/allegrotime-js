class @ScheduleView
  update: ->
    crossing = Crossing.current()
    $(".navbar.for-schedule .title span").text(crossing.name)

    min_percent = 100/360
    build_div = (color, duration) ->
      $('<div>', class: "duration #{color}", css: { width: "#{duration * min_percent}%"})

    build_graph = (since, till) ->
      container = $("#schedule-graph .graph-#{since}-#{till} .box")
      min = since * 60
      max = till * 60
      stop = min
      closings = crossing.closings.filter (cl) -> cl.trainTime >= min && cl.trainTime < max

      container.html('')
      for closing in closings
        duration = closing.trainTime - 20 - stop
        if duration <= 0
          container.append build_div 'red', closing.trainTime - stop
        else
          container.append build_div 'gray', duration
          container.append build_div 'yellowred', 20
        stop = closing.trainTime
      container.append build_div 'gray', max - stop

      title_container = $("#schedule-graph .graph-#{since}-#{till} .title")
      unless $("span.mark", title_container).length
        for hour in [since..till]
          percent = if hour == till then 100 else hour % 6 / 6 * 100
          classes = ['mark']
          classes.push 'zero' if hour < 10
          classes.push "p#{percent.toFixed()}"
          indicator = $("<span>", class: classes.join(' '), text: hour, 'data-hour': hour)
          title_container.append(indicator)

      $("span.mark", title_container).removeClass('current')
      $("span.mark[data-hour=#{Helper.current_hour()}]", title_container).addClass('current')


    build_graph  6, 12
    build_graph 12, 18
    build_graph 18, 24


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
