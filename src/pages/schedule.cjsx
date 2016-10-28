{Page, Body, Navbar, Navbar, NavbarLink, NavbarButton, NavbarTitle, NavbarButtonStub} = UI
{ScheduleGraph, ScheduleTable} = UI

defineComponent 'Schedule',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing: Allegro.Crossing.current
    minutes: app.state.minutes

  render: ->
    crossing = @state.crossing

    <Page id='schedule' tab='schedule'>
      <Navbar>
        <NavbarButtonStub side='left'/>
        <NavbarTitle>{crossing.name}</NavbarTitle>
        <NavbarButtonStub side='right'/>
      </Navbar>

      <Body wrapper=yes>
        <ScheduleGraph crossing=crossing hour=util.current_hour() />
        <ScheduleTable crossing=crossing />
      </Body>
    </Page>
