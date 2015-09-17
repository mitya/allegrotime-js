describe 'Crossing', ->
  set_time = (time_string) ->
    @time_spy ?= spyOn(Helper, 'minutes_since_midnight')
    @time_spy.andReturn Helper.minutes_from_hhmm(time_string)
    # console.log Helper.minutes_from_hhmm(time_string)
  
  reset_time = ->
    @time_spy = null
  
  beforeEach ->
    @crossing = new Crossing('Удельная')
    reset_time()

  it 'constructor', ->
    expect(@crossing.name).toBe 'Удельная'
    expect(@crossing.closings).toEqual []

  it "state and color", ->
    expect(@crossing.state()).toBe 'Unknown'
    expect(@crossing.color()).toBe 'Gray'

    new Closing('12:10', 'FIN', @crossing)
    new Closing('14:10', 'FIN', @crossing)

    set_time '10:59'; expect(@crossing.state()).toBe 'Clear';      expect(@crossing.color()).toBe 'Green'
    set_time '11:00'; expect(@crossing.state()).toBe 'Soon';       expect(@crossing.color()).toBe 'Green'
    set_time '11:30'; expect(@crossing.state()).toBe 'VerySoon';   expect(@crossing.color()).toBe 'Yellow'
    set_time '11:49'; expect(@crossing.state()).toBe 'VerySoon'
    set_time '11:50'; expect(@crossing.state()).toBe 'Closing';    expect(@crossing.color()).toBe 'Red'
    set_time '11:51'; expect(@crossing.state()).toBe 'Closing'
    set_time '11:55'; expect(@crossing.state()).toBe 'Closing'
    set_time '12:00'; expect(@crossing.state()).toBe 'Closed';     expect(@crossing.color()).toBe 'Red'
    set_time '12:05'; expect(@crossing.state()).toBe 'Closed'
    set_time '12:10'; expect(@crossing.state()).toBe 'JustOpened'; expect(@crossing.color()).toBe 'Yellow'
    set_time '12:11'; expect(@crossing.state()).toBe 'JustOpened'
    set_time '12:15'; expect(@crossing.state()).toBe 'JustOpened'
    set_time '12:20'; expect(@crossing.state()).toBe 'Clear';      expect(@crossing.color()).toBe 'Green'

  it "state for Poklonnogorskaya", ->
    expect(new Crossing('Поклонногорская').state()).toBe 'Closed'
    
  it "has schedule check", ->
    expect(@crossing.hasSchedule()).toBe false

    crossing = new Crossing('crossing with a closing')
    new Closing('12:10', 'FIN', crossing)
    expect(crossing.hasSchedule()).toBe true

  it "next closing", ->
    new Closing('12:10', 'FIN', @crossing)
    new Closing('14:10', 'FIN', @crossing)
    new Closing('16:10', 'FIN', @crossing)
    
    set_time '13:00'
    expect(@crossing.previousClosing().rawTime).toBe '12:10'
    expect(@crossing.nextClosing().rawTime).toBe '14:10'
