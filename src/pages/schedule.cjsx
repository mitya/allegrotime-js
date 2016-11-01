import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { ScheduleGraph } from '../components/schedule_graph'
import { ScheduleTable } from '../components/schedule_table'
import { EventedComponent } from './evented_component'

class Schedule extends React.Component
  @propTypes =
    crossing: React.PropTypes.object.isRequired

  render: ->
    crossing = @props.crossing

    <Page id='schedule' tab='schedule'>
      <Navbar>
        <Navbar.ButtonStub side='left'/>
        <Navbar.Title>{crossing.name}</Navbar.Title>
        <Navbar.ButtonStub side='right'/>
      </Navbar>

      <Page.Body wrapper=yes>
        <ScheduleGraph crossing=crossing hour=$U.currentHour() />
        <ScheduleTable crossing=crossing />
      </Page.Body>
    </Page>

export Schedule = EventedComponent(Schedule)
