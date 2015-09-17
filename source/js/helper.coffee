@Helper =
  minutes_from_hhmm: (string) ->
    components = string.split ":"
    hours   = parseInt components[0]
    minutes = parseInt components[1]
    hours * 60 + minutes

  minutes_since_midnight: ->
    now = new Date()
    midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0)
    ms_since_midnight = now.getTime() - midnight.getTime()
    Math.floor ms_since_midnight / 60 / 1000
