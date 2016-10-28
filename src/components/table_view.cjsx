defineComponent 'TableView',
  render: ->
    <div className="list-block #{@props.className ? ''}">
      <ul>
        { @props.children }
      </ul>
    </div>

defineComponent 'TableViewItem',
  render: ->
    content =
      if @props.custom
        <div className="item-custom #{@props.className ? ''}">
          {@props.children}
        </div>
      else
        <div className="item-content #{@props.className ? ''}">
          {
            if @props.icon
              <div className="item-media">
                <i className="icon #{@props.icon}"></i>
              </div>
          }
          <div className="item-inner">
            <div className="item-title">{@props.title}</div>
          </div>
        </div>

    if @props.to
      <li>
        <Link onClick=@props.onClick to=@props.to className='item-link'>
          {content}
        </Link>
      </li>
    else
      <li onClick=@props.onClick>
        {content}
      </li>
