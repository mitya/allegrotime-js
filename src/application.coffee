import './css/application.scss'
import './lib/extensions'
import Reactor from './reactor'
import AppState from './app_state'
import Schedule from './models/schedule'
import {setupRoutes} from './routes'

window.shouldRotateToOrientation = -> true
window.util = require('./lib/utilities')
window.dispatch = require('./models/dispatcher').default
window.AllegroTime_Data = require('./models/data')

document.addEventListener cordova? && "deviceready" || "DOMContentLoaded", ->
  FastClick.attach(document.body)
  $('body').addClass device.platform.toLowerCase() if window.device

  window.app = new AppState
  Schedule.load()
  setupRoutes()
  new Reactor().start()
