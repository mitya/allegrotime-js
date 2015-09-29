describe 'Closing', ->
  beforeEach ->
    @crossing = new Crossing('Test Crossing')
    @closing  = new Closing('23:10', 'toFinland', @crossing)

  it 'has a constructor', ->
    expect(@closing.crossing).toBe @crossing
    expect(@closing.rawTime).toBe '23:10'
    expect(@closing.direction).toBe 'toFinland'
    expect(@closing.trainTime).toBeDefined()

  it 'stores the train time as an integer of minutes since midnight', ->
    expect(@closing.trainTime).toBe 23*60 + 10

  it 'knows that the closing time is 10 minutes before the train time', ->
    expect(@closing.closingTime()).toBe 23*60

  it 'formats the #time based on the train time', ->
    expect(new Closing('23:10').time()).toBe '23:10'
    expect(new Closing(' 3:10').time()).toBe '03:10'

  it 'generates a realistic train number', ->
    expect(@closing.trainNumber()).toBe 781

