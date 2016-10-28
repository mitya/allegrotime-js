{Page, Body, Navbar, Navbar, NavbarLink, NavbarButton, NavbarTitle, NavbarButtonStub} = UI

defineComponent 'Status',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing = Allegro.Crossing.current

    crossing: crossing
    minutes: app.state.minutes
    canSwitchToClosest: Allegro.Crossing.closest && !crossing.isClosest

  render: ->
    # console.log arguments.callee.displayName

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
        <NavbarButton side='left' to='about' icon='info' />
        <NavbarTitle>АллегроТайм</NavbarTitle>
        {
          if @state.canSwitchToClosest
            <NavbarButton side='right' onClick={@clickLocate} icon='locate' />
          else
            <NavbarButtonStub />
        }
      </Navbar>

      <Body wrapper=yes>
        <CTableView className='status-table'>
          <CTableViewItem title=crossing_name to='crossings' className='crossing-select' />
          <CTableViewItem custom=yes className="custom-row status-view #{crossing_css_class} crossing-message">{status_message}</CTableViewItem>
          <CTableViewItem custom=yes className='custom-row text small'>{crossing_status}</CTableViewItem>
          <CTableViewItem custom=yes className='custom-row text small'>{train_status}</CTableViewItem>
          <CTableViewItem custom=yes className='status-alert'>
            <div className='width-limiting-box'>{alert}</div>
          </CTableViewItem>
          <CTableViewItem custom=yes className='status-notice'>
            <div className='width-limiting-box'>{notice}</div>
          </CTableViewItem>
        </CTableView>
      </Body>
    </Page>

  clickLocate: -> dispatch CHANGE_CROSSING_TO_CLOSEST


  # <ul className='debug-log'>
  #   {
  #     for data, i in app.state.log.slice(0).reverse()
  #       <li key=i>{data.time.toLocaleTimeString()} {data.text}</li>
  #   }
  # </ul>
