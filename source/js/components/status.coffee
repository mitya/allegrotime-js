defineComponent 'Status',
  componentDidMount: ->
    console.log "status did mount"

  render: ->
    crossing = @props.crossing || Crossing.current()
    nextClosing = crossing.nextClosing()

    crossing_name = crossing.name
    crossing_css_class = crossing.color().toLowerCase()
    status_message = crossing.subtitle()
    crossing_status = "Переезд #{crossing.isClosed() && "закрыли" || "закроют"} примерно в #{Helper.minutes_as_hhmm(nextClosing.closingTime())}"
    train_status = "Аллегро пройдет примерно в #{Helper.minutes_as_hhmm(nextClosing.trainTime)}"

    if crossing.name == 'Поклонногорская'
      crossing_status = 'Откроют в декабре 2016 (предположительно)'
      train_status = ''

    alert = if AllegroTime_Data.alert
      AllegroTime_Data.alert

    notice = if crossing.updated_at
      "Расписание переезда «#{crossing.name}» обновлено #{crossing.updated_at}"
    else
      "Расписание переезда «#{crossing.name}» рассчитано приблизительно, на основе расписания других переездов."

    <CPage padded=yes id="statusbox">
      <CNavbar>
        <CNavbarLink side='left' to='/about' peIcon='7s-info' />
        <CNavbarTitle>
          <span className="brand">АллегроТайм</span>
        </CNavbarTitle>
        <CNavbarButton side='right' onClick={@clickLocate}>
          {
            if Crossing.closest() && !crossing.isClosest()
              <img src="images/icons/define_location.png" height="23" width="23" className="btn" />
          }
        </CNavbarButton>
      </CNavbar>

      <CBody>
        <p id="crossing_name" className="row text-row first disclosure touchable">
          <Link to="/crossings">{crossing_name}</Link>
        </p>
        <p className="row statusrow #{crossing_css_class}" id="status_message">{status_message}</p>
        <p className="row text-row small" id="crossing_status">{crossing_status}</p>
        <p className="row text-row small" id="train_status">{train_status}</p>

        <div id='#adblock'></div>

        <p className="status-alert">{alert}</p>
        <p className="status-notice">{notice}</p>
      </CBody>
    </CPage>

  clickLocate: -> Crossing.setCurrentToClosest(); location.hash = 'status'
