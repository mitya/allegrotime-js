defineComponent 'Layout',
  render: ->
    <div>
      { @props.children }
      <CTabbar />
    </div>

defineComponent 'Body',
  render: ->
    <div className="page-content" id=@props.id>
      { @props.children }
    </div>

defineComponent 'Page',
  render: ->
    padded_class = @props.padded && 'page-padded' || ''
    # classes = cssClasses(@props.padded: 'page-padded')
    <div className="page #{padded_class}" id=@props.id>
      { @props.children }
    </div>

defineComponent 'Tabbar',
  render: ->
    <div id="tabbar">
      <ul className="tabs">
        <li className="tab statusbox">
          <Link to="status">
            <div className="image"></div>
            <div className="title">Статус</div>
          </Link>
        </li>
        <li className="tab schedule">
          <Link to="schedule">
            <div className="image"></div>
            <div className="title">Расписание</div>
          </Link>
        </li>
      </ul>
    </div>
