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
