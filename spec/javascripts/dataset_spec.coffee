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
    expect(Model.closestCrossing()).toEqual Crossing.getCrossingWithName('Удельная')
    expect(Model.currentCrossing()).toEqual Crossing.getCrossingWithName('Удельная')
