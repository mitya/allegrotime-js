$ ->
  $("#tabbar li.schedule").click ->
    $('#container').load "schedule.html"

  $("#tabbar li.status").click ->
    $('#container').load "status.html"

  $("#navbar li.about").click ->
    $('#container').load "about.html"
