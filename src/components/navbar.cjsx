import CustomLink from "./link"

export Navbar = ({children}) ->
  <nav className="navbar" id="navbar">
    <div className="navbar-inner">
      { children }
    </div>
  </nav>

Navbar.Title = ({className, value, children}) ->
  <div className={ util.cssClasses('center', className) }>
    { value ? children }
  </div>

Navbar.Button = ({side, to, icon, onClick}) ->
  <div className=side onClick=onClick>
  {
    if icon
      <Link to=to className="link icon-only">
        <i className="icon icon-#{icon}"></i>
      </Link>
  }
  </div>

Navbar.ButtonStub = ({side}) ->
  <Navbar.Button side={side ? 'right'} icon='none' />

class Navbar.BackButton extends React.Component
  componentDidMount: ->
    app.back = @props.to

  componentWillUnmount: ->
    delete app.back

  render: ->
    <Navbar.Button side='left' to=@props.to icon='back' />

Navbar.Link = ({props}) ->
  render: ->
    buttonProps = _.omit(props, ['to', 'children'])
    <Navbar.Button {...buttonProps} noPadding>
      <CustomLink to=props.to>
        {
          if props.peIcon
            <span className="icon pe-#{props.peIcon}"></span>
          else
            props.children
        }
      </CustomLink>
    </Navbar.Button>
