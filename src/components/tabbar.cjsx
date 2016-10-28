defineComponent 'Tabbar',
  render: ->
    <div className="toolbar tabbar tabbar-labels" id="tabbar">
      <div className="toolbar-inner">
        <UI.TabbarLink name='status' activeName={@props.activeTab} text='Статус' />
        <UI.TabbarLink name='schedule' activeName={@props.activeTab} text='Расписание'/>
      </div>
    </div>

defineComponent 'TabbarLink',
  render: ->
    classes = util.cssClasses('tab-link', @props.name is @props.activeName && 'active')

    <Link to={@props.to ? @props.name} className=classes>
      <i className="icon tab-icon #{@props.name}">
      {
        if @props.badge
          <span className="badge bg-red">{@props.badge}</span>
      }
      </i>
      <span className="tabbar-label">{@props.text}</span>
    </Link>
