defineComponent 'Schedule',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing: Crossing.current(), minutes: ds.minutes

  render: ->
    console.log arguments.callee.displayName
    crossing = @state.crossing

    <CPage id='schedule' tab='schedule'>
      <CNavbar>
        <CNavbarButton side='left' />
        <CNavbarTitle value=crossing.name />
      </CNavbar>

      <CBody>
        <CScheduleGraph crossing=crossing hour=util.current_hour() />
        <CScheduleTable crossing=crossing />
      </CBody>
    </CPage>
