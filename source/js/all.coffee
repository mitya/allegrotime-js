#= require "helper"
#= require "models/crossing"
#= require "models/closing"
#= require "models/model"

$ ->
  $("#tabbar li.schedule").click -> $('#container').load "schedule.html"
  $("#tabbar li.status").click -> $('#container').load "status.html"
  $("#navbar li.about").click -> $('#container').load "about.html"
  # $('#container').load "schedule.html", -> App.update_ui()

  window.Model = new ModelManager
  window.Model.init()

  # Model.setCurrentCrossing(Crossing.get("Парголово"))
  App.update_ui()

  $(document).on 'model-updated', -> App.update_ui()

@App =
  update_ui: ->
    @update_status()
    @update_schedule()

  update_status: ->
    crossing = Model.currentCrossing()
    $('#crossing_name').text(crossing.name)
    $('#status_message').removeClass('green yellow red gray').addClass crossing.color().toLowerCase()
    $('#status_message').text crossing.subtitle()
    $('#navbar .title').text(Model.currentCrossing().name)

  update_schedule: ->
    crossing = Model.currentCrossing()
    $('#schedule .tableview tr').each (index) ->
      closing = crossing.closings[index]
      $('th', this).text closing.time()
