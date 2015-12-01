defineComponent 'Crossings',
  componentDidMount: ->
    console.log "crossings did mount"

  render: ->
    crossings = ds.crossings.all

    <CPage padded=yes tabbar=no id="crossings">

      <CNavbar>
        <CNavbarBackButton to='/' />
        <CNavbarTitle value='Переезды'/>
      </CNavbar>

      <CBody>
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
      </CBody>
    </CPage>

  select: (crossing) ->
    crossing.makeCurrent()
    @props.history.pushState(null, '/')
