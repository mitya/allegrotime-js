class @AboutView
  before_show: ->
    $('#about .schedule-update-ts').text Schedule.current.updated_at

    if cordova.getAppVersion
      cordova.getAppVersion.getVersionNumber (version) ->
        $('#about span.app-version').text version
