import { Page } from '../components/page'
import { Navbar } from '../components/navbar'
import { TableView } from '../components/table_view'
{Crossing} = Allegro

export class Status extends React.Component
  constructor: ->
    super
    @state = @initialState()

  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  initialState: ->
    crossing = Crossing.current
    crossing: crossing
    minutes: app.state.minutes
    canSwitchToClosest: Crossing.closest && !crossing.isClosest

  update: =>
    newState = @initialState()
    @setState(newState) unless _.isEqual(newState, @state)

  render: ->
    crossing = @state.crossing
    nextClosing = crossing.nextClosing

    crossing_name = crossing.name
    crossing_css_class = crossing.color.toLowerCase()
    status_message = crossing.subtitle
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
          if @state.canSwitchToClosest
            <Navbar.Button side='right' onClick={@clickLocate} icon='locate' />
          else
            <Navbar.ButtonStub />
        }
      </Navbar>

      <Page.Body wrapper=yes>
        <TableView className='status-table'>
          <TableView.Item title=crossing_name to='crossings' className='crossing-select' />
          <TableView.Item custom=yes className="custom-row status-view #{crossing_css_class} crossing-message">{status_message}</TableView.Item>
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

  clickLocate: -> dispatch CHANGE_CROSSING_TO_CLOSEST


  # <ul className='debug-log'>
  #   {
  #     for data, i in app.state.log.slice(0).reverse()
  #       <li key=i>{data.time.toLocaleTimeString()} {data.text}</li>
  #   }
  # </ul>
