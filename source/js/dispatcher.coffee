@MODEL_UPDATED = 'MODEL_UPDATED'
@CHANGE_CROSSING = 'CHANGE_CROSSING'
@CHANGE_CROSSING_TO_CLOSEST = 'CHANGE_CROSSING_TO_CLOSEST'
@MINUTE_CHANGED = 'MINUTE_CHANGED'
@POSITION_CHANGED = 'POSITION_CHANGED'

@dispatch = (action, data = {}) ->
  console.log action, data
  switch action
    when CHANGE_CROSSING
      data.crossing.makeCurrent()
    when CHANGE_CROSSING_TO_CLOSEST
      Crossing.setCurrentToClosest()
    when MINUTE_CHANGED
      ds.minutes = data.minutes
      util.trigger(MODEL_UPDATED, 'app.timerTicked')
    when POSITION_CHANGED
      ds.position = data.position
      Crossing.updateClosest(data.position.coords)
    else
      console.error "unknown action:", action

  setTimeout data.delay, 150 if data.delay
  # setTimeout ( -> history.pushState(null, data.delayRoute)), 150 if data.delayRoute
