defineComponent 'ScheduleTable',
  render: ->
    console.log 'render ScheduleTable'

    crossing = @props.crossing
    closing_pairs = _.zip crossing.closingsForFromRussiaTrains(), crossing.closingsForFromFinlandTrains()

    Cell = (closing) ->
      classes = util.cssClasses(
        'allegro' if closing.isAllegro(),
        'sv' if closing.isSV(),
        'pv' if closing.isPV(),
        'disabled' if !closing.isToday(),
        closing.color().toLowerCase() if closing.isClosest()
      )

      <th className="#{closing.directionKey()} time status-view #{classes}" data-train="#{closing.trainNumber}">
        <div className="time">
          {closing.time()}
          <span className="marks"> </span>
        </div>
      </th>

    Row = (pair, index) ->
      <tr key=index>
        {Cell pair[1]}
        {Cell pair[0]}
      </tr>

    <section id="schedule-table">
      <table className="tableview">
        <thead>
          <tr>
            <th className="time">
              <div className="time"> На СПб </div>
            </th>
            <th className="time">
              <div className="time"> От СПб </div>
            </th>
          </tr>
        </thead>

        <tbody>
          { closing_pairs.map(Row) }
        </tbody>
      </table>
    </section>
