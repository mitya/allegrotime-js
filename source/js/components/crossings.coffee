UI.Crossings = React.createClass
  render: ->
    <table className="tableview one-column with-crossing-status">
      {
        @props.crossings.map (crossing) ->
          <tr data-key=crossing.name key=crossing.name className="touchable">
            <td className="image"><div className="statusrow #{crossing.color().toLowerCase()}"></div></td>
            <td className="text #{crossing.isCurrent() && 'checkmark'}">{crossing.name}</td>
          </tr>
      }
    </table>
