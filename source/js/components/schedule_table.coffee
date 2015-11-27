UI.ScheduleTable = React.createClass
  displayName: 'ScheduleTable'
  render: ->
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
        { @props.closing_pairs.map(Row) }
      </tbody>
    </table>
