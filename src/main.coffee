require './css/imports.scss'
require './css/styles.scss'
require 'framework7/dist/css/framework7.ios.css'
require 'framework7/dist/css/framework7.ios.colors.css'

window.$ = require('jQuery')
window._ = require("underscore")
window.React = require('react')
window.attachFastClick = require('fastclick')

window.UI = {}
window.Link = require('react-router').Link
window.Allegro = {}

window.defineComponent = (name, definition) ->
  definition.displayName ?= name
  klass = React.createClass(definition)
  window["C#{name}"] = klass
  window.UI[name] = klass

window.shouldRotateToOrientation = -> true

window.dispatch = require('./dispatcher')
window.util = require('./lib/utilities')
window.AllegroTime_Data = require('./data')

require "framework7"

require './lib/extensions'
require './models/closing'
require './models/crossing'
require './models/schedule'
require './models/train'
require './components/page'
require './components/navbar'
require './components/tabbar'
require './components/table_view'
require './components/link'
require './components/schedule_graph'
require './components/schedule_table'
require './pages/about'
require './pages/crossings'
require './pages/schedule'
require './pages/status'
require './app'
