MIN_DURATION = 100 / 360

Handlebars.registerHelper 'durationToWidth', (duration) ->
  (duration * MIN_DURATION).toFixed(4)
