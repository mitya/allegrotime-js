class @ModelManager
  # attr_accessor :crossings, :closings, :closestCrossing, :selectedCrossing
  # attr_accessor :currentCrossingChangeTime

  defaultCrossing: ->
    Crossing.getCrossingWithName "Удельная"
  
  closestCrossing: ->
    @defaultCrossing()
    # return null unless App.isLocationAvailable()
    # @closestCrossingObj ||= @crossingClosestTo App.locationManager.location, :active
  
  selectedCrossing: ->
    @defaultCrossing()
    crossingName = localStorage.selectedCrossing
    if crossingName then Crossing.getCrossingWithName(crossingName) else null
    # crossingName && Crossing.getCrossingWithName(crossingName)
  
  setSelectedCrossing: (crossing) ->
    localStorage.selectedCrossing if crossing then crossing.name else null
    # localStorage.selectedCrossing crossing && crossing.name
  
  currentCrossing: ->
    @selectedCrossing() || @closestCrossing() || @defaultCrossing()
  
  setCurrentCrossing: (crossing) ->
    @selectedCrossingObj = if crossing.isClosest() then null else crossing
    # @currentCrossingChangeTime = new Date
    # Device.notify ATModelUpdated
    
  reverseCrossings: ->
    @crossingsReversed ||= @crossings.slice(0).reverse()
    
  activeCrossings: ->
    @crossingsActive ||= @crossings.filter (crossing) -> crossing.hasSchedule() && !crossing.isDisabled()
  
  realClosestCrossing: ->
    # @crossingClosestTo App.locationManager.location, :all
  
  crossingClosestTo: (location, collection) ->
    # source = collection == :active ? activeCrossings : crossings
    # source.minimumObject -> (crossing) do
    #   currentLocation = CLLocation.alloc.initWithLatitude crossing.latitude, longitude:crossing.longitude
    #   currentLocation.distanceFromLocation location

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
      
