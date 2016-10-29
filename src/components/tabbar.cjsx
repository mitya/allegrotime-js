export Tabbar = ({activeTab}) ->
  <div className="toolbar tabbar tabbar-labels" id="tabbar">
    <div className="toolbar-inner">
      <Tabbar.Link name='status' activeName={activeTab} text='Статус' />
      <Tabbar.Link name='schedule' activeName={activeTab} text='Расписание'/>
    </div>
  </div>

Tabbar.Link = ({name, activeName, to, badge, text}) ->
  classes = util.cssClasses('tab-link', name is activeName && 'active')

  <Link to={to ? name} className=classes>
    <i className="icon tab-icon #{name}">
    {
      if badge
        <span className="badge bg-red">{badge}</span>
    }
    </i>
    <span className="tabbar-label">{text}</span>
  </Link>
