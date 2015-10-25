class @CrossingsView
  constructor: ->
    $("#crossings .tableview").on 'click', 'tr', (e) => @change_crossing_to $(e.target).text()

  before_show: ->
    @tableview = $('#crossings .tableview')
    @initialize() unless $('tr', @tableview).length
    @tableview.find('tr td.checkmark').removeClass('checkmark')
    @selected_row = @tableview.find('tr').filter( -> this.dataset.key == Crossing.current().name)
    @selected_row.find('td.text').addClass('checkmark')

  after_show: (animated) ->
    $('body').animate scrollTop: @selected_row.position().top - 200, 150 if animated

  initialize: ->
    for crossing in Crossing.crossings
      row = $('<tr>', 'data-key': crossing.name, class: "touchable")
      row.append $('<td>', class: 'image', html: $('<div>', class: "statusrow #{crossing.color().toLowerCase()}"))
      row.append $('<td>', class: 'text').text(crossing.name)
      @tableview.append(row)

  update: ->
    $('#crossings .tableview tr').each (i, row) =>
      row = $(row)
      crossing = Crossing.get row.data('key')
      row.find('.statusrow').removeClass('red green yellow gray').addClass crossing.color().toLowerCase()

  change_crossing_to: (crossing_name) ->
    Crossing.setCurrent Crossing.get(crossing_name)
    App.status_nav_controller.pop()
