UI.Crossings = React.createClass
  displayName: 'CrossingsList'

  render: ->
    <div className="page no-tabbar" id="crossings">

      <div className="navbar-box" id="navbar">
        <ul className="navbar">
          <li className="buttons left" onClick={@back}>
            <img className='back-button' src='images/icons/custom_back.png' height=20 width=20 />
          </li>
          <li className="title">
            <span className="brand">Переезды</span>
          </li>
          <li className="buttons right"></li>
        </ul>
      </div>

      <div className="page-content">
        <table className="tableview one-column with-crossing-status">
          <tbody>
            {
              @props.crossings.map (crossing) =>
                <tr data-key=crossing.name key=crossing.name className="touchable" onClick={@select.bind(null, crossing)}>
                  <td className="image"><div className="statusrow #{crossing.color().toLowerCase()}"></div></td>
                  <td className="text #{crossing.isCurrent() && 'checkmark'}">{crossing.name}</td>
                </tr>
            }
          </tbody>
        </table>
      </div>

    </div>

  select: (crossing) ->
    crossing.makeCurrent()
    @back()

  back: ->
    App.status_view.update()
