defineComponent 'Crossings',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing = Crossing.current()
    crossing: crossing, minutes: ds.minutes

  render: ->
    console.log arguments.callee.displayName
    crossings = ds.crossings
    selectedCrossing = @state.crossing

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
                  <td className="text #{crossing == selectedCrossing && 'checkmark'}">{crossing.name}</td>
                </tr>
            }
          </tbody>
        </table>
      </CBody>
    </CPage>

  select: (crossing) ->
    dispatch CHANGE_CROSSING, crossing: crossing, delay: => @props.history.pushState(null, '/')
