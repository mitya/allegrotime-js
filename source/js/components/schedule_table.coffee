defineComponent 'ScheduleTable',
  render: ->
    crossing = Crossing.current()
    closings_infos_rus = (new ClosingInfo(c) for c in crossing.closingsForFromRussiaTrains())
    closings_infos_fin = (new ClosingInfo(c) for c in crossing.closingsForFromFinlandTrains())
    closing_pairs = _.zip(closings_infos_rus, closings_infos_fin)

    Cell = (closing) ->
      <th className="#{closing.directionKey} time statusrow #{closing.css}" data-train="#{closing.trainNumber}">
        <div className="time">
          {closing.time}
          <span className="marks"> </span>
        </div>
      </th>

    Row = (pair, index) ->
      <tr key=index>
        {Cell pair[1]}
        {Cell pair[0]}
      </tr>

    <div id="schedule-table">
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
    </div>
