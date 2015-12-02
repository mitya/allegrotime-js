defineComponent 'Layout',
  render: ->
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

