export class CustomLink extends React.Component
  click: (e) ->
    return if CustomLink.touchModeEnabled
    @performAction()

  touchStart: (e) ->
    CustomLink.touchModeEnabled = true
    @performAction()

  touchEnd: (e) ->
    # touch = e.changedTouches[0]
    # endElement = document.elementFromPoint(touch.clientX, touch.clientY)
    # if @refs.span == endElement || @refs.span.contains(endElement)
    #   @performAction()

  performAction: ->
    app.history.push(@props.to)

  render: ->
    <span className='link' ref='span' href=@props.to onClick=@click onTouchStart=@touchStart onTouchEnd=@touchEnd>
      { @props.children }
    </span>
