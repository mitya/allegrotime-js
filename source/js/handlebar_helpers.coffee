MIN_DURATION = 100 / 360

Handlebars.registerHelper
  durationToWidth: (duration) -> duration * MIN_DURATION
  # crossingCssClass: (crossing) -> crossing.color().toLowerCase()
  # crossingCssClass: -> @crossing.color().toLowerCase()
  iff: (condition, string) -> if condition then string else ""
