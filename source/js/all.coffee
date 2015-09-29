#= require "helper"
#= require "models/crossing"
#= require "models/closing"
#= require "models/model"

$ ->
  $("#tabbar li.schedule").click ->
    $('#container').load "schedule.html"

  $("#tabbar li.status").click ->
    $('#container').load "status.html"

  $("#navbar li.about").click ->
    $('#container').load "about.html"

  $('#container').load "schedule.html"

  window.Model = new ModelManager
  window.Model.init()

  App.update_status()

  $(document).on 'model-updated', ->
    console.log 'up'
    App.update_status()

@App =
  update_status: ->
    $("#crossing_name").text(Model.currentCrossing().name)
    $("#navbar .title").text(Model.currentCrossing().name)
