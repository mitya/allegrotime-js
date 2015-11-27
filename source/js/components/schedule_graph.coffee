UI.ScheduleGraph = React.createClass
  displayName: 'ScheduleGraph'
  render: ->
    <div className='schedule-graph-inner'>
      {
        @props.lines.map (line) ->
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
    </div>
