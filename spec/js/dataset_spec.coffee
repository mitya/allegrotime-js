{Crossing} = Allegro

describe 'Dataset', ->
  it 'has some data', ->
    expect(AllegroTime_Data).toBeDefined()
    expect(AllegroTime_Data.rows.length).toEqual(27)

  it "is loaded when the app is launched", ->
    expect(app.state.crossings.length).toEqual(27)
    expect(app.state.closings.length).toEqual(app.state.crossings.length * 16)
    expect(app.state.crossings[0].name).toEqual('Удельная')
    expect(app.state.crossings[0].closings.length).toEqual(16)

  it "has a default crossing set", ->
    expect(Crossing.default).toEqual Crossing.get('Удельная')

    Crossing.setCurrent Crossing.get('Парголово')
    expect(Crossing.current).toBe Crossing.get('Парголово')

  it "calculates closest crossing to some point", ->
    expect( Crossing.closestTo(latitude: 60.106213, longitude: 30.154899) ).toBe Crossing.get('Песочный')
    expect( Crossing.closestTo(latitude: 60.311217, longitude: 29.561562) ).toBe Crossing.get('Горьковское')