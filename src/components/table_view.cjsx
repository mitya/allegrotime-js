export TableView = ({className, children}) ->
  <div className="list-block #{className ? ''}">
    <ul>
      { children }
    </ul>
  </div>

TableView.Item = Item = ({children, custom, className, icon, to, title, onClick}) ->
  content =
    if custom
      <div className="item-custom #{className ? ''}">
        {children}
      </div>
    else
      <div className="item-content #{className ? ''}">
        {
          if icon
            <div className="item-media">
              <i className="icon #{icon}"></i>
            </div>
        }
        <div className="item-inner">
          <div className="item-title">{title}</div>
        </div>
      </div>

  if to
    <li>
      <Link onClick=onClick to=to className='item-link'>
        {content}
      </Link>
    </li>
  else
    <li onClick=onClick>
      {content}
    </li>
