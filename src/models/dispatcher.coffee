defineAction = (action) -> window[action] = action
defineAction 'MODEL_UPDATED'
defineAction 'CHANGE_CROSSING'
defineAction 'CHANGE_CROSSING_TO_CLOSEST'
defineAction 'MINUTE_CHANGED'
defineAction 'POSITION_CHANGED'
defineAction 'APP_AWAKED'
defineAction 'CHECK_SCHEDULE_UPDATES_IF_NEEDED'

import Crossing from './crossing'

export default dispatch = (action, data = {}) ->
  console.log "app.dispatch", action, data
  switch action
    when CHANGE_CROSSING
      data.crossing.makeCurrent()
    when CHANGE_CROSSING_TO_CLOSEST
      Crossing.setCurrentToClosest()
    when MINUTE_CHANGED
      appState.minutes = data.minutes
      app.trigger(MODEL_UPDATED, 'app.timerTicked')
    when APP_AWAKED
      app.trigger(MODEL_UPDATED, 'app.resume')
    when POSITION_CHANGED
      appState.position = data.position
      Crossing.updateClosest(data.position.coords)
    when CHECK_SCHEDULE_UPDATES_IF_NEEDED
      Schedule.updateIfNeeded()
    when APP_AWAKED
      app.trigger(MODEL_UPDATED, 'app.resume')
    else
      console.error "unknown action:", action

  setTimeout data.delay, 150 if data.delay
  # setTimeout ( -> app.router.history.push(data.delayRoute)), 150 if data.delayRoute
