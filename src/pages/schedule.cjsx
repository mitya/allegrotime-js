import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { ScheduleGraph } from '../components/schedule_graph'
import { ScheduleTable } from '../components/schedule_table'

export class Schedule extends React.Component
  constructor: ->
    super
    @state = @initialState()

  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  initialState: ->
    crossing: Allegro.Crossing.current, minutes: app.state.minutes

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  render: ->
    crossing = @state.crossing

    <Page id='schedule' tab='schedule'>
      <Navbar>
        <Navbar.ButtonStub side='left'/>
        <Navbar.Title>{crossing.name}</Navbar.Title>
        <Navbar.ButtonStub side='right'/>
      </Navbar>

      <Page.Body wrapper=yes>
        <ScheduleGraph crossing=crossing hour=util.current_hour() />
        <ScheduleTable crossing=crossing />
      </Page.Body>
    </Page>
