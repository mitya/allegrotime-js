describe 'Dataset', ->
  it 'has some data', ->
    expect(AllegroTime_Data).toBeDefined()
    expect(AllegroTime_Data.rows.length).toEqual(29)
    
  it "is loaded when the app is launched", ->
    expect(model.crossings.length).toEqual(27)
    expect(model.closings.length).toEqual(model.crossings.length * 8)
    expect(model.crossings[0].name).toEqual('Удельная')
    expect(model.crossings[0].closings.length).toEqual(8)
