defineComponent 'Schedule',
  componentDidMount: ->
    $(document).on 'model-updated', @update

  componentWillUnmount: ->
    $(document).off 'model-updated', @update

  update: ->
    console.log 'schedule updated'
    newState = crossing: Crossing.current(), minutes: ds.minutes
    @setState(newState) if @state.crossing != newState.crossing || @state.minutes != newState.minutes

  getInitialState: ->
    crossing: Crossing.current(), minutes: ds.minutes

  render: ->
    console.log 'render schedule'
    crossing = @state.crossing

    <CPage id='schedule' tab='schedule'>
      <CNavbar>
        <CNavbarButton side='left' />
        <CNavbarTitle value="Расписание" />
      </CNavbar>

      <CBody>
        <CScheduleGraph crossing=crossing hour=util.current_hour />
        <CScheduleTable crossing=crossing />
      </CBody>
    </CPage>
