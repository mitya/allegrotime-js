defineAction = (action) -> window[action] = action
defineAction 'MODEL_UPDATED'
defineAction 'CHANGE_CROSSING'
defineAction 'CHANGE_CROSSING_TO_CLOSEST'
defineAction 'MINUTE_CHANGED'
defineAction 'POSITION_CHANGED'
defineAction 'APP_AWAKED'

import Crossing from './crossing'

export default dispatch = (action, data = {}) ->
  console.log "dispatch", action, data
  switch action
    when CHANGE_CROSSING
      data.crossing.makeCurrent()
    when CHANGE_CROSSING_TO_CLOSEST
      Crossing.setCurrentToClosest()
    when MINUTE_CHANGED
      app.state.minutes = data.minutes
      util.trigger(MODEL_UPDATED, 'app.timerTicked')
    when APP_AWAKED
      util.trigger(MODEL_UPDATED, 'app.resume')
    when POSITION_CHANGED
      app.state.position = data.position
      Crossing.updateClosest(data.position.coords)
    else
      console.error "unknown action:", action

  setTimeout data.delay, 150 if data.delay
  # setTimeout ( -> app.router.history.push(data.delayRoute)), 150 if data.delayRoute
