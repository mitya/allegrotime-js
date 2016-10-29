import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { TableView } from '../components/table_view'
import { EventedComponent } from './evented_component'

class Status extends React.Component
  @propTypes =
    crossing: React.PropTypes.object.isRequired
    minutes: React.PropTypes.number.isRequired
    canSwitchToClosest: React.PropTypes.bool

  clickLocate: -> dispatch CHANGE_CROSSING_TO_CLOSEST

  render: ->
    crossing = @props.crossing
    nextClosing = crossing.nextClosing

    crossing_status = "Переезд #{crossing.isClosed && "закрыли" || "закроют"} примерно в #{util.minutes_as_hhmm(nextClosing.closingTime)}"
    train_status = "Аллегро пройдет примерно в #{util.minutes_as_hhmm(nextClosing.trainTime)}"

    if crossing.name == 'Поклонногорская'
      crossing_status = 'Откроют в декабре 2016 (предположительно)'
      train_status = ''

    alert = if AllegroTime_Data.alert
      AllegroTime_Data.alert

    notice = if crossing.updated_at
      "Расписание переезда «#{crossing.name}» обновлено #{crossing.updated_at}"
    else
      "Расписание переезда «#{crossing.name}» рассчитано приблизительно, на основе расписания других переездов."

    <Page id='status' tab='status'>
      <Navbar>
        <Navbar.Button side='left' to='about' icon='info' />
        <Navbar.Title>АллегроТайм</Navbar.Title>
        {
          if @props.canSwitchToClosest
            <Navbar.Button side='right' onClick={@clickLocate} icon='locate' />
          else
            <Navbar.ButtonStub />
        }
      </Navbar>

      <Page.Body wrapper=yes>
        <TableView className='status-table'>
          <TableView.Item title={crossing.name} to='crossings' className='crossing-select' />
          <TableView.Item custom=yes className="custom-row status-view #{crossing.color.toLowerCase()} crossing-message">
            {crossing.subtitle}
          </TableView.Item>
          <TableView.Item custom=yes className='custom-row text small'>{crossing_status}</TableView.Item>
          <TableView.Item custom=yes className='custom-row text small'>{train_status}</TableView.Item>
          <TableView.Item custom=yes className='status-alert'>
            <div className='width-limiting-box'>{alert}</div>
          </TableView.Item>
          <TableView.Item custom=yes className='status-notice'>
            <div className='width-limiting-box'>{notice}</div>
          </TableView.Item>
        </TableView>
      </Page.Body>
    </Page>

export Status = EventedComponent(Status)
