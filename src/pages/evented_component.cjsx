import Crossing from '../models/crossing'

export EventedComponent = (TargetComponent) ->
  React.createClass
    displayName: "Evented#{TargetComponent.name}"
    componentDidMount: -> app.on MODEL_UPDATED, @update
    componentWillUnmount: -> app.off MODEL_UPDATED, @update

    getInitialState: ->
      crossing: Crossing.current
      minutes: appState.minutes
      canSwitchToClosest: Crossing.closest && !Crossing.current.isClosest

    update: ->
      newState = @getInitialState()
      @setState(newState) unless _.isEqual(newState, @state)

    render: ->
      <TargetComponent {...@state} />
