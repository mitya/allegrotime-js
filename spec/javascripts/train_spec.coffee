describe 'Train', ->
  it 'know the run days', ->
    expect( Train.get(782).runsOn(0) ).toBe true
    expect( Train.get(782).runsOn(1) ).toBe true
    expect( Train.get(782).runsOn(6) ).toBe true

    expect( Train.get(7203).runsOn(1) ).toBe false
    expect( Train.get(7203).runsOn(0) ).toBe true
    expect( Train.get(7203).runsOn(6) ).toBe true

    expect( Train.get(7206).runsOn(1) ).toBe false
    expect( Train.get(7206).runsOn(0) ).toBe true
    expect( Train.get(7206).runsOn(6) ).toBe true

    # expect( Train.get(7209).runs(1) ).toBe false
    # expect( Train.get(7209).runs(6) ).toBe false
    # expect( Train.get(7209).runs(0) ).toBe true
    # expect( Train.get(7209).runs(5) ).toBe true

  it 'shows the comment for on/off days', ->
    expect( Train.get(782).daysComment ).toBe null
    expect( Train.get(7203).daysComment ).toBe 'SV'
