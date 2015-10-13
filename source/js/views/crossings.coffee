class @CrossingsView
  constructor: ->
    $("#crossings .tableview").on 'click', 'tr', (e) => @change_crossing_to $(e.target).text()

  before_show: ->
    @tableview = $('#crossings .tableview')
    @initialize() unless $('tr', @tableview).length
    @tableview.find('tr td.checkmark').removeClass('checkmark')
    @selected_row = @tableview.find('tr').filter( -> this.dataset.key == Model.currentCrossing().name)
    @selected_row.find('td.text').addClass('checkmark')

  after_show: (animated) ->
    $('body').animate scrollTop: @selected_row.position().top - 200, 150 if animated

  initialize: ->
    for crossing in Model.crossings
      row = $('<tr>', 'data-key': crossing.name, class: "touchable")
      row.append $('<td>', class: 'image', html: $('<div>', class: "statusrow #{crossing.color().toLowerCase()}"))
      row.append $('<td>', class: 'text').text(crossing.name)
      @tableview.append(row)

  change_crossing_to: (crossing_name) ->
    Model.setCurrentCrossing Crossing.get(crossing_name)
    App.status_nav_controller.pop()
