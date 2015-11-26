class @CrossingsView
  constructor: ->
    $("#crossings").on 'click', '.tableview tr', (e) => @change_crossing_to $(e.target).text()

  after_show: (animated) ->
    current_crossing = Crossing.current()
    selected_row = $('#crossings .tableview tr').filter( -> @dataset.key == current_crossing.name)
    $('body').animate scrollTop: selected_row.position().top - 200, 150 if animated

  update: ->
    console.time("update Crossings List")

    Helper.benchmark 'crossings', =>
      # crossings_data = (new CrossingInfo(c) for c in Crossing.all)
      # $('#crossings .content').html HandlebarsTemplates['crossings'](crossings: crossings_data)

      React.render <UI.Crossings crossings=Crossing.all />, $('#crossings').get(0)

    console.timeEnd("update Crossings List")

  change_crossing_to: (crossing_name) ->
    Crossing.setCurrent Crossing.get(crossing_name)
    App.status_nav_controller.pop()
