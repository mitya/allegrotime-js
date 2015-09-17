describe 'Closing', ->
  beforeEach ->
    @crossing = new Crossing('Test Crossing')
    @closing  = new Closing('23:10', 'toFinland', @crossing)

  it 'constructor', ->
    expect(@closing.crossing).toBe @crossing
    expect(@closing.rawTime).toBe '23:10'
    expect(@closing.direction).toBe 'toFinland'
    expect(@closing.trainTime).toBeDefined()

  it 'train time', ->
    expect(@closing.trainTime).toBe 23*60 + 10
  
  it 'closing time', ->
    expect(@closing.closingTime()).toBe 23*60

  it 'time', ->
    expect(new Closing('23:10').time()).toBe '23:10'
    expect(new Closing(' 3:10').time()).toBe '03:10'

  it 'train number', ->
    expect(@closing.trainNumber()).toBe 781

