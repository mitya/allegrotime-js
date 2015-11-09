class @AboutView
  before_show: ->
    $('#about .schedule-update-ts').text Schedule.current.updated_at
