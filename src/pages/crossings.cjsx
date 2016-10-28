defineComponent 'Crossings',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing = Allegro.Crossing.current
    crossing: crossing, minutes: app.state.minutes

  render: ->
    crossings = app.state.crossings
    selectedCrossing = @state.crossing

    <CPage padded=yes id="crossings" tab=no>
      <CNavbar>
        <CNavbarBackButton to='status' />
        <CNavbarTitle>Переезды</CNavbarTitle>
        <CNavbarButtonStub />
      </CNavbar>

      <CBody wrapper=yes>
        <CTableView>
        {
          for crossing in crossings
            <CTableViewItem
              key     = crossing.name
              title   = crossing.name
              icon    = "status-icon status-icon-#{crossing.color.toLowerCase()}"
              onClick = {@select.bind(null, crossing)}
            />
        }
        </CTableView>
      </CBody>
    </CPage>

  select: (crossing) ->
    dispatch CHANGE_CROSSING, crossing: crossing, delay: => app.history.push('/')
