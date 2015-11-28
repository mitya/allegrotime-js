defineComponent 'Navbar',
  render: ->
    <div id="navbar">
      <ul className="navbar">
        { @props.children }
      </ul>
    </div>

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
    <UI.NavbarLink side='left' to=@props.to>
      <img className='back-button' src='images/icons/custom_back.png' height=20 width=20 />
    </UI.NavbarLink>

defineComponent 'NavbarLink',
  render: ->
    buttonProps = _.omit(@props, ['to', 'children'])
    <UI.NavbarButton {...buttonProps}>
      <Link to=@props.to>
        {
          if @props.peIcon
            <span className="icon pe-#{@props.peIcon}"></span>
          else
            @props.children
        }
      </Link>
    </UI.NavbarButton>

# navbarItemContent = (props) ->
