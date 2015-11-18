@StatusComponent = React.createClass
  displayName: 'Status'
  getInitialState: ->
    console.log 'getInitialState'
    var1: '111', var2: '222'

  componentDidMount: ->
    console.log 'componentDidMount'
    x = 0 unless x
    setInterval =>
      console.log 'tick'
      x = x + 1
      @setState var1: "111 #{x}"
    , 1000

  render: ->
    <div className="status-inner">
      <p className="row text-row first disclosure touchable" id="crossing_name">{@props.crossing_name}</p>
      <p className="row statusrow #{@props.status_class}" id="status_message">{@props.status_message}</p>
      <p className="row text-row small" id="crossing_status">{@props.crossing_status}</p>
      <p className="row text-row small" id="train_status">{@props.train_status}</p>

      <div id='#adblock'>{@state.var1} and {@state.var2}</div>

      <p className="status-alert">{@props.alert}</p>
      <p className="status-notice">{@props.notice}</p>
    </div>
