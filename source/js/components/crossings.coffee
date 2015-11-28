defineComponent 'Crossings',
  componentDidMount: ->
    console.log "crossings did mount"

  render: ->
    crossings = Crossing.all

    <UI.Page padded=yes tabbar=no id="crossings">

      <UI.Navbar>
        <UI.NavbarBackButton to='/' />
        <UI.NavbarTitle value='Переезды'/>
      </UI.Navbar>

      <UI.Body>
        <table className="tableview one-column with-crossing-status">
          <tbody>
            {
              crossings.map (crossing) =>
                <tr data-key=crossing.name key=crossing.name className="touchable" onClick={@select.bind(null, crossing)}>
                  <td className="image"><div className="statusrow #{crossing.color().toLowerCase()}"></div></td>
                  <td className="text #{crossing.isCurrent() && 'checkmark'}">{crossing.name}</td>
                </tr>
            }
          </tbody>
        </table>
      </UI.Body>
    </UI.Page>

  select: (crossing) ->
    crossing.makeCurrent()
    @props.history.pushState(null, '/')
