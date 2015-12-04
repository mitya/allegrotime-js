defineComponent 'Status',
  componentDidMount: -> $(document).on MODEL_UPDATED, @update
  componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

  update: ->
    newState = @getInitialState()
    @setState(newState) unless _.isEqual(newState, @state)

  getInitialState: ->
    crossing = Crossing.current()
    crossing: crossing, minutes: ds.minutes, canSwitchToClosest: Crossing.closest() && !crossing.isClosest()

  render: ->
    # console.log arguments.callee.displayName

    crossing = @state.crossing
    nextClosing = crossing.nextClosing()

    crossing_name = crossing.name
    crossing_css_class = crossing.color().toLowerCase()
    status_message = crossing.subtitle()
    crossing_status = "Переезд #{crossing.isClosed() && "закрыли" || "закроют"} примерно в #{util.minutes_as_hhmm(nextClosing.closingTime())}"
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

    <CPage padded=yes id='status' tab='status'>
      <CNavbar>
        <CNavbarLink side='left' to='/about' peIcon='7s-info' />
        <CNavbarTitle className='brand' value='АллегроТайм' />
        <CNavbarButton side='right' onClick={@clickLocate}>
          {
            if @state.canSwitchToClosest
              <img src="images/icons/define_location.png" height="23" width="23" className="btn" />
          }
        </CNavbarButton>
      </CNavbar>

      <CBody>
        <p className="row text first disclosure touchable crossing-name">
          <Link to="/crossings">{crossing_name}</Link>
        </p>
        <p className="row status-view #{crossing_css_class} crossing-message" >{status_message}</p>
        <p className="row text small">{crossing_status}</p>
        <p className="row text small">{train_status}</p>

        <div className='adblock'></div>

        <p className="status-alert">{alert}</p>
        <p className="status-notice">{notice}</p>

      </CBody>
    </CPage>

  clickLocate: -> dispatch CHANGE_CROSSING_TO_CLOSEST


  # <ul className='debug-log'>
  #   {
  #     for data, i in ds.log.slice(0).reverse()
  #       <li key=i>{data.time.toLocaleTimeString()} {data.text}</li>
  #   }
  # </ul>
