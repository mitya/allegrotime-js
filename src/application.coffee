import './css/application.scss'
import './lib/extensions'
import Reactor from './reactor'
import Schedule from './models/schedule'
import dispatch from './models/dispatcher'
import {setupRoutes, getHistory} from './routes'

window.shouldRotateToOrientation = -> true
window.$U = require('./lib/utilities').default
window.AllegroTime_Data = require('./models/data')

document.addEventListener cordova? && "deviceready" || "DOMContentLoaded", ->
  FastClick.attach(document.body)
  $('body').addClass device.platform.toLowerCase() if window.device

  window.app = new Application()
  window.appState = getInitialAppState()
  Schedule.load()
  setupRoutes()
  app.history = getHistory()
  new Reactor().start()

getInitialAppState = ->
  minutes: $U.minutesSinceMidnight $U.now()
  log: []

class Application
  dispatch: dispatch
  trigger: (event, source) -> $(document).trigger event, source: source
  on: (event, callback) -> $(document).on event, callback
  off: (event, callback) -> $(document).off event, callback
