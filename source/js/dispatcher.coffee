window.MODEL_UPDATED = 'MODEL_UPDATED'
window.CHANGE_CROSSING = 'CHANGE_CROSSING'
window.CHANGE_CROSSING_TO_CLOSEST = 'CHANGE_CROSSING_TO_CLOSEST'
window.MINUTE_CHANGED = 'MINUTE_CHANGED'
window.POSITION_CHANGED = 'POSITION_CHANGED'

dispatch = (action, data = {}) ->
  console.log ":: dispatch", action, data
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
  # setTimeout ( -> app.router.history.push(data.delayRoute)), 150 if data.delayRoute

module.exports = dispatch
