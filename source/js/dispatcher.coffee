@CHANGE_CROSSING = 'CHANGE_CROSSING'
@CHANGE_CROSSING_TO_CLOSEST = 'CHANGE_CROSSING_TO_CLOSEST'

@dispatch = (action, data = {}) ->
  console.log action, data
  switch action
    when CHANGE_CROSSING
      data.crossing.makeCurrent()
    when CHANGE_CROSSING_TO_CLOSEST
      Crossing.setCurrentToClosest()
    else
      console.error "unknown action:", action

  setTimeout data.delay, 150 if data.delay
  # setTimeout ( -> history.pushState(null, data.delayRoute)), 150 if data.delayRoute
