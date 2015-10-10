class @ModelManager
  # attr_accessor :crossings, :closings, :closestCrossing, :selectedCrossing
  # attr_accessor :currentCrossingChangeTime

  defaultCrossing: ->
    Crossing.get "Удельная"

  closestCrossing: ->
    @_closestCrossing

  selectedCrossing: ->
    localStorage.selectedCrossing && Crossing.get(localStorage.selectedCrossing)

  currentCrossing: ->
    @selectedCrossing() || @closestCrossing() || @defaultCrossing()

  setSelectedCrossing: (crossing) ->
    localStorage.selectedCrossing = crossing && crossing.name || null
    $(document).trigger('model-updated')

  setCurrentCrossing: (crossing) ->
    if crossing.isClosest()
      delete localStorage.selectedCrossing
    else
      @setSelectedCrossing crossing

  reverseCrossings: ->
    @crossingsReversed ||= @crossings.slice(0).reverse()

  activeCrossings: ->
    @crossingsActive ||= @crossings.filter (crossing) -> crossing.hasSchedule() && !crossing.isDisabled()

  realClosestCrossing: ->
    @crossingClosestTo App.current_position.coords

  crossingClosestTo: (coords) ->
    closest_crossing = null
    closest_distance = Infinity
    for crossing in @crossings when !crossing.isDisabled()
      distance = crossing.distanceFrom(coords.latitude, coords.longitude)
      if distance < closest_distance
        closest_crossing = crossing
        closest_distance = distance
    closest_crossing

  updateClosestCrossing: (coords) ->
    closest = @crossingClosestTo(coords)
    if closest != @_closestCrossing
      @_closestCrossing = @crossingClosestTo(coords)
      $(document).trigger('model-updated')

  init: ->
    @crossings = []

    for row in AllegroTime_Data.rows
      [name, dist, lat, lng, closingTimes...] = row

      continue if name == 'Санкт-Петербург' || name == 'Выборг'

      crossing = new Crossing(name)
      crossing.distance  = parseInt dist
      crossing.latitude  = parseFloat lat
      crossing.longitude = parseFloat lng

      new Closing closingTimes[0], 'RUS', crossing
      new Closing closingTimes[4], 'FIN', crossing
      new Closing closingTimes[1], 'RUS', crossing
      new Closing closingTimes[5], 'FIN', crossing
      new Closing closingTimes[2], 'RUS', crossing
      new Closing closingTimes[6], 'FIN', crossing
      new Closing closingTimes[3], 'RUS', crossing
      new Closing closingTimes[7], 'FIN', crossing

      @crossings.push crossing

    @closings = []
    for crossing in @crossings
      @closings.push.apply(@closings, crossing.closings)

