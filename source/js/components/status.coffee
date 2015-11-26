UI.Status = React.createClass
  # getInitialState: ->
  #   console.log 'getInitialState'
  #   var1: '111', var2: '222'
  #
  # getDefaultProps: ->
  #   crossing_name: 'XXXXXX'
  #
  # componentDidMount: ->
  #   console.log 'componentDidMount'
  #   x = 0 unless x
  #   setInterval =>
  #     console.log 'tick'
  #     x = x + 1
  #     @setState var1: "111 #{x}"
  #   , 1000
  #
  # propTypes: ->
  #   crossing_name: React.PropTypes.number.isRequired
  #   crossing: React.PropTypes.instanceOf(Crossing).isRequired
  #   fuck: React.PropTypes.any.isRequired

  render: ->
    <div className="status-inner">
      <p className="row text-row first disclosure touchable" id="crossing_name">{@props.crossing_name}</p>
      <p className="row statusrow #{@props.crossing.color().toLowerCase()}" id="status_message">{@props.status_message}</p>
      <p className="row text-row small" id="crossing_status">{@props.crossing_status}</p>
      <p className="row text-row small" id="train_status">{@props.train_status}</p>

      <div id='#adblock'></div>

      <p className="status-alert">{@props.alert}</p>
      <p className="status-notice">{@props.notice}</p>
    </div>

# @LikeButton = React.createClass
#   getInitialState: ->
#     liked: false, message: 'gooo'
#   handleClick: (e) ->
#     @setState liked: !@state.liked
#     @setState message: @state.liked && "like" || "don't like"
#   render: ->
#     text = @state.liked && "like" || "don't like"
#     <p onClick={@handleClick}>
#       You {@state.message} it!
#     </p>
