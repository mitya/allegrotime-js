defineComponent 'Link',
  click: (e) ->
    return if CLink.touchModeEnabled
    console.log 'click', CLink.touchModeEnabled
    console.log this
    @performAction()

  touchStart: (e) ->
    console.log 'touch start'
    console.log this
    CLink.touchModeEnabled = true
    @performAction()

  touchEnd: (e) ->
    # touch = e.changedTouches[0]
    # endElement = document.elementFromPoint(touch.clientX, touch.clientY)
    # if @refs.span == endElement || @refs.span.contains(endElement)
    #   @performAction()

  performAction: ->
    console.log 'go to', @props.to
    app.router.history.push(@props.to)

  render: ->
    <span className='link' ref='span' href=@props.to onClick=@click onTouchStart=@touchStart onTouchEnd=@touchEnd>
      { @props.children }
    </span>
