class ModelManager
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
    @loadFile()    
  
  loadFile: ->
    @crossings = []
    for components in AllegroTime_Dataset.rows
      [name, dist, lat, lng, closingTimes...] = components
      console.log name, dist, closingTimes

      continue if name == 'Санкт-Петербург' || name == 'Выборг'

      crossing = new Crossing
      crossing.name      = name
      crossing.distance  = parseInt dist
      crossing.latitude  = parseFloat lat
      crossing.longitude = parseFloat lng
      
      if components.objectAtIndex(4) != ''
        crossing.closings = NSMutableArray.arrayWithCapacity(8)

        lastDatumIndex = 3
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 1), direction:Closing::DirectionToFinland
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 5), direction:Closing::DirectionToRussia
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 2), direction:Closing::DirectionToFinland
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 6), direction:Closing::DirectionToRussia
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 3), direction:Closing::DirectionToFinland
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 7), direction:Closing::DirectionToRussia
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 4), direction:Closing::DirectionToFinland
        crossing.addClosingWithTime components.objectAtIndex(lastDatumIndex + 8), direction:Closing::DirectionToRussia
      else
        crossing.closings = []
            
      @crossings.addObject crossing
    
    @closings = []
    @closings.concat crossing.closings for crossing in @crossings
