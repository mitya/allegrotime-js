describe 'Dataset', ->
  it 'has some data', ->
    expect(AllegroTime_Data).toBeDefined()
    expect(AllegroTime_Data.rows.length).toEqual(29)

  it "is loaded when the app is launched", ->
    expect(Model.crossings.length).toEqual(27)
    expect(Model.closings.length).toEqual(Model.crossings.length * 8)
    expect(Model.crossings[0].name).toEqual('Удельная')
    expect(Model.crossings[0].closings.length).toEqual(8)

  it "has a default crossing set", ->
    expect(Model.defaultCrossing()).toEqual Crossing.get('Удельная')
    expect(Model.closestCrossing()).toEqual Crossing.get('Удельная')

    Model.setCurrentCrossing Crossing.get('Парголово')
    expect(Model.currentCrossing()).toBe Crossing.get('Парголово')

  it "calculates closest crossing to some point", ->
    expect( Model.crossingClosestTo(latitude: 60.106213, longitude: 30.154899) ).toBe Crossing.get('Песочный')
    expect( Model.crossingClosestTo(latitude: 60.311217, longitude: 29.561562) ).toBe Crossing.get('Горьковское')
