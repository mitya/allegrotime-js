class @ScheduleView
  update: ->
    @crossing = Crossing.current()
    $(".navbar.for-schedule .title span").text(@crossing.name)

    @update_graph()
    @update_table()

  update_graph: ->
    build_graph = (since, till) =>
      min = since * 60
      max = till * 60
      stop = min
      closings = @crossing.todayClosings().filter (cl) -> cl.trainTime >= min && cl.trainTime < max
      spans = []
      indicators = []

      for closing in closings
        duration = closing.trainTime - 20 - stop
        if duration <= 0
          spans.push color: 'red', duration: closing.trainTime - stop
        else
          spans.push color: 'green', duration: duration
          spans.push color: 'yellow', duration: 10
          spans.push color: 'red', duration: 10
        stop = closing.trainTime
      spans.push color: 'green', duration: max - stop

      for hour in [since..till]
        percent = if hour == till then 100 else hour % 6 / 6 * 100
        classes = ['mark']
        classes.push 'zero' if hour < 10
        classes.push "p#{percent.toFixed()}"
        indicators.push classes: classes.join(' '), hour: hour

      from:  since, to: till, spans: spans, indicators: indicators

    Helper.benchmark 'update schedule graph', =>
      # $('#schedule-graph').html HandlebarsTemplates['schedule_graph'](
      #   lines: [build_graph(6, 12), build_graph(12, 18), build_graph(18, 24)]
      # )

      lines = [build_graph(6, 12), build_graph(12, 18), build_graph(18, 24)]
      ReactDOM.render <CScheduleGraph lines=lines />, $('#schedule-graph').get(0)

      # $("span.mark", title_container).removeClass('current')
      # $("span.mark[data-hour=#{Helper.current_hour()}]", title_container).addClass('current')

  update_table: ->
    Helper.benchmark 'update schedule table', =>
      closings_infos_rus = (new ClosingInfo(c) for c in @crossing.closingsForFromRussiaTrains())
      closings_infos_fin = (new ClosingInfo(c) for c in @crossing.closingsForFromFinlandTrains())
      closing_pairs = _.zip(closings_infos_rus, closings_infos_fin)

      # $('#schedule-table').html HandlebarsTemplates['schedule_table'](closing_pairs: closing_pairs)
      ReactDOM.render <CScheduleTable closing_pairs=closing_pairs />, $('#schedule-table').get(0)
