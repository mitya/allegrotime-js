MIN_DURATION = 100 / 360

Handlebars.registerHelper 'durationToWidth', (duration) ->
  duration * MIN_DURATION

Handlebars.registerHelper 'crossingCssClass', (crossing) ->
  crossing.color().toLowerCase()

Handlebars.registerHelper 'iff', (condition, string) ->
  if condition then string else ""
