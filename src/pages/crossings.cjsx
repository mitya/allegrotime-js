import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { TableView } from '../components/table_view'

export class Crossings extends React.Component
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  constructor: ->
    super
    @state = @initialState()

  update: ->
    newState = @initialState()
    @setState(newState) unless _.isEqual(newState, @state)

  initialState: ->
    crossing = Allegro.Crossing.current
    crossing: crossing, minutes: app.state.minutes

  render: ->
    crossings = app.state.crossings
    selectedCrossing = @state.crossing

    <Page padded=yes id="crossings" tab=no>
      <Navbar>
        <Navbar.BackButton to='status' />
        <Navbar.Title>Переезды</Navbar.Title>
        <Navbar.ButtonStub />
      </Navbar>

      <Page.Body wrapper=yes>
        <TableView>
        {
          for crossing in crossings
            <TableView.Item
              key     = crossing.name
              title   = crossing.name
              icon    = "status-icon status-icon-#{crossing.color.toLowerCase()}"
              onClick = {@select.bind(null, crossing)}
            />
        }
        </TableView>
      </Page.Body>
    </Page>

  select: (crossing) ->
    dispatch CHANGE_CROSSING, crossing: crossing, delay: => app.history.push('/')
