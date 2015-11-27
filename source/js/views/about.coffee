class @AboutView
  before_show: ->
    $('#about .schedule-update-ts').text Schedule.current.updated_at

    cordova.getAppVersion?.getVersionNumber (version) ->
      $('#about span.app-version').text version

  update: ->
    Helper.benchmark 'update about', =>
      React.render <UI.About />, $e('container')
