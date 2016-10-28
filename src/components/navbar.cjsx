defineComponent 'Navbar',
  render: ->
    <nav className="navbar" id="navbar">
      <div className="navbar-inner">
        { @props.children }
      </div>
    </nav>

defineComponent 'NavbarTitle',
  render: ->
    <div className={ util.cssClasses('center', @props.className) }>
      { @props.value ? @props.children }
    </div>

defineComponent 'NavbarButton',
  render: ->
    <div className=@props.side onClick=@props.onClick>
    {
      if @props.icon
        <Link to=@props.to className="link icon-only">
          <i className="icon icon-#{@props.icon}"></i>
        </Link>
    }
    </div>

defineComponent 'NavbarButtonStub',
  render: ->
    <CNavbarButton side={@props.side ? 'right'} icon='none' />

defineComponent 'NavbarBackButton',
  componentDidMount: ->
    app.back = @props.to

  componentWillUnmount: ->
    delete app.back

  render: ->
    <CNavbarButton side='left' to=@props.to icon='back' />

defineComponent 'NavbarLink',
  render: ->
    buttonProps = _.omit(@props, ['to', 'children'])
    <CNavbarButton {...buttonProps} noPadding>
      <CLink to=@props.to>
        {
          if @props.peIcon
            <span className="icon pe-#{@props.peIcon}"></span>
          else
            @props.children
        }
      </CLink>
    </CNavbarButton>
