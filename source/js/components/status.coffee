UI.Status = React.createClass
  displayName: 'Status'

  render: ->
    crossing = @props.crossing
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

    <div className="page page-padded">

      <div className="navbar-box" id="navbar">
        <ul className="navbar">
          <li className="buttons left about" onClick={@clickAbout}>
            <span className="icon pe-7s-info"></span>
          </li>
          <li className="title">
            <span className="brand">АллегроТайм</span>
          </li>
          <li className="buttons right locate" onClick={@clickLocate}>
            {
              if Crossing.closest() && !crossing.isClosest()
                <img src="images/icons/define_location.png" height="23" width="23" className="btn" />
            }
          </li>
        </ul>
      </div>

      <div className="page-content" id="statusbox">
        <p id="crossing_name" className="row text-row first disclosure touchable" onClick={@clickCrossings}>
          {crossing_name}
        </p>
        <p className="row statusrow #{crossing_css_class}" id="status_message">{status_message}</p>
        <p className="row text-row small" id="crossing_status">{crossing_status}</p>
        <p className="row text-row small" id="train_status">{train_status}</p>

        <div id='#adblock'></div>

        <p className="status-alert">{alert}</p>
        <p className="status-notice">{notice}</p>
      </div>

    </div>

  clickAbout: -> App.about_view.update()
  clickLocate: -> Crossing.setCurrentToClosest(); App.status_view.update()
  clickCrossings: -> App.crossings_view.update()
