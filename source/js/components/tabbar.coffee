defineComponent 'Tabbar',
  render: ->
    activeIf = (tabName) => if @props.activeTab == tabName then 'active' else ''

    <div id="tabbar">
      <ul className="tabs">
        <li className="tab statusbox #{activeIf('status')}">
          <CLink to="/status">
            <div className="image"></div>
            <div className="title">Статус</div>
          </CLink>
        </li>
        <li className="tab schedule #{activeIf('schedule')}">
          <CLink to="/schedule">
            <div className="image"></div>
            <div className="title">Расписание</div>
          </CLink>
        </li>
      </ul>
    </div>
