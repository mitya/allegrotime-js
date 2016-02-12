//= require_tree ./lib
//= require_tree ./models
//= require_tree ./components
//= require dispatcher

//= require jquery/dist/jquery.min
//= require underscore/underscore-min
//= require fastclick/lib/fastclick
//= require react/react.min
//= require react/react-dom.min
//= require react-router/umd/ReactRouter.min
//= require history/umd/History.min

require('../css/imports.scss')
require('../css/styles.scss')

window.$ = require('jQuery')
window._ = require("underscore")
window.React = require('react')
window.ReactDOM = require('react-dom')
window.ReactRouter = require('react-router')
window.ReactHistory = require('history')
window.attachFastClick = require('fastclick')

window.UI = {}
window.Link = ReactRouter.Link
window.Allegro = {}


window.defineComponent = require('./setup').defineComponent
window.dispatch = require('./dispatcher')
window.util = require('./lib/utilities')
require('./lib/extensions')
require('./models/closing')
require('./models/crossing')
require('./models/schedule')
require('./models/train')
require('./components/about')
require('./components/crossings')
require('./components/layout')
require('./components/link')
require('./components/navbar')
require('./components/schedule_graph')
require('./components/schedule_table')
require('./components/schedule')
require('./components/status')
require('./components/tabbar')
require('./app')

// window.addEventListener 'load', ->
//   attachFastClick(document.body)


