defineComponent 'Layout',
  render: ->
    console.log 'render layout'
    <div>
      { @props.children }
    </div>

defineComponent 'Page',
  render: ->
    classes = util.cssClasses('padded' if @props.padded, 'no-tabbar' unless @props.tab)
    <div className="page #{classes}" id=@props.id>
      { @props.children }
      { <CTabbar activeTab=@props.tab /> if @props.tab }
    </div>

defineComponent 'Body',
  render: ->
    <section className="container" id=@props.id>
      { @props.children }
    </section>

defineComponent 'Tabbar',
  render: ->
    activeIf = (tabName) => if @props.activeTab == tabName then 'active' else ''

    <div id="tabbar">
      <ul className="tabs">
        <li className="tab statusbox #{activeIf('status')}">
          <Link to="status">
            <div className="image"></div>
            <div className="title">Статус</div>
          </Link>
        </li>
        <li className="tab schedule #{activeIf('schedule')}">
          <Link to="schedule">
            <div className="image"></div>
            <div className="title">Расписание</div>
          </Link>
        </li>
      </ul>
    </div>
