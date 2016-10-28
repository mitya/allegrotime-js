defineComponent 'Layout',
  render: ->
    <div className='layout-box'>
      { @props.children }
    </div>

defineComponent 'Page',
  render: ->
    classes = util.cssClasses(
      'tabbar-labels-fixed' if @props.tab
    )
    <div className='views'>
      <div className='view'>
        <div className=''>
          <div className="page #{classes} navbar-fixed" id=@props.id>
            { @props.children }
            { <CTabbar activeTab=@props.tab /> if @props.tab }
          </div>
        </div>
      </div>
    </div>

defineComponent 'Body',
  render: ->
    classes = util.cssClasses(
      'page-content' if @props.wrapper,
      'page-padding' if @props.padding
    )
    <article id=@props.id className=classes>
      { @props.children }
    </article>

# app = new Framework7({})
# app.addView(".view")
