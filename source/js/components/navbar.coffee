defineComponent 'Navbar',
  render: ->
    <nav id="navbar">
      <ul className="navbar">
        { @props.children }
      </ul>
    </nav>

defineComponent 'NavbarButton',
  render: ->
    <li {...@props} className="buttons #{@props.side}">
      { @props.children }
    </li>

defineComponent 'NavbarTitle',
  render: ->
    <li className="title">
      <span className="brand">{ @props.value || @props.children }</span>
    </li>

defineComponent 'NavbarBackButton',
  render: ->
    <CNavbarLink side='left' to=@props.to>
      <img className='back-button' src='images/icons/custom_back.png' height=20 width=20 />
    </CNavbarLink>

defineComponent 'NavbarLink',
  render: ->
    buttonProps = _.omit(@props, ['to', 'children'])
    <CNavbarButton {...buttonProps}>
      <Link to=@props.to>
        {
          if @props.peIcon
            <span className="icon pe-#{@props.peIcon}"></span>
          else
            @props.children
        }
      </Link>
    </CNavbarButton>
