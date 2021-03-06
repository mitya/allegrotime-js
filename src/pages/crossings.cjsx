import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { TableView } from '../components/table_view'
import { EventedComponent } from './evented_component'

class Crossings extends React.Component
  render: ->
    crossings = appState.crossings
    selectedCrossing = @props.crossing

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
    app.dispatch CHANGE_CROSSING, crossing: crossing, delay: => app.history.push('/')

export Crossings = EventedComponent(Crossings)
