defineComponent 'ScheduleGraph',
  render: ->
    crossing = @props.crossing

    build_graph = (since, till) =>
      min = since * 60
      max = till * 60
      stop = min
      closings = crossing.todayClosings().filter (cl) -> cl.trainTime >= min && cl.trainTime < max
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

    lines = [build_graph(6, 12), build_graph(12, 18), build_graph(18, 24)]

    # FIX current hour

    <section id='schedule-graph'>
      {
        lines.map (line) ->
          <div className="graph graph-#{line.from}-#{line.to}" key="#{line.from}#{line.to}">
            <div className="durations">
              {
                line.spans.map (span, i) ->
                  <span className="duration #{span.color}" style={width: "#{span.duration * 100 / 360}%"} key=i></span>
              }
            </div>
            <div className="marks">
              {
                line.indicators.map (line, i) ->
                  <span className=line.classes data-hour=line.hour key=line.hour>{line.hour}</span>
              }
            </div>
          </div>
        }
    </section>
