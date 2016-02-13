describe 'Closing', ->
  beforeEach ->
    @crossing = new Allegro.Crossing('Test Crossing')
    @closing  = new Allegro.Closing('23:10', @crossing, 782)

  it 'has a constructor', ->
    expect(@closing.crossing).toBe @crossing
    expect(@closing.rawTime).toBe '23:10'
    expect(@closing.trainNumber).toBe 782
    expect(@closing.train).toBe Allegro.Train.get(782)
    expect(@closing.trainTime).toBeDefined()
    expect(@closing.toRussia).toBe true

  it 'stores the train time as an integer of minutes since midnight', ->
    expect(@closing.trainTime).toBe 23*60 + 10

  it 'knows that the closing time is 10 minutes before the train time', ->
    expect(@closing.closingTime).toBe 23*60

  it 'formats the #time based on the train time', ->
    expect(new Allegro.Closing('23:10').time).toBe '23:10'
    expect(new Allegro.Closing(' 3:10').time).toBe '03:10'
    expect(new Allegro.Closing(' 3:07').time).toBe '03:07'
