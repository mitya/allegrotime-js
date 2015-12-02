defineComponent 'Crossings',
  componentDidMount: ->
    console.log arguments.callee.displayName

  render: ->
    console.log arguments.callee.displayName
    crossings = ds.crossings

    <CPage padded=yes id="crossings" tab=no>

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
                  <td className="image"><div className="status-view #{crossing.color().toLowerCase()}"></div></td>
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
