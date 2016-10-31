import './css/styles.scss'

window.shouldRotateToOrientation = -> true

window.UI = {}
window.Allegro = {}
window.util = require('./lib/utilities')
window.dispatch = require('./models/dispatcher')
window.AllegroTime_Data = require('./models/data')

require './lib/extensions'
require './models/closing'
require './models/crossing'
require './models/schedule'
require './models/train'
require './app'

document.addEventListener cordova? && "deviceready" || "DOMContentLoaded", ->
  FastClick.attach(document.body)
  window.app = new Allegro.App
  app.start()
