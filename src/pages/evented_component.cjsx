import Crossing from '../models/crossing'

export EventedComponent = (TargetComponent) ->
  React.createClass
    displayName: "Evented#{TargetComponent.name}"
    componentDidMount: -> $(document).on MODEL_UPDATED, @update
    componentWillUnmount: -> $(document).off MODEL_UPDATED, @update

    getInitialState: ->
      crossing: Crossing.current
      minutes: app.state.minutes
      canSwitchToClosest: Crossing.closest && !Crossing.current.isClosest

    update: ->
      console.log 'updated'
      newState = @getInitialState()
      @setState(newState) unless _.isEqual(newState, @state)

    render: ->
      <TargetComponent {...@state} />
