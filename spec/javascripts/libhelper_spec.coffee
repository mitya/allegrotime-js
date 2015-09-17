describe 'Helper', ->
  it 'minutes_from_hhmm', ->
    expect(Helper.minutes_from_hhmm('12:45')).toBe 12*60 + 45
    expect(Helper.minutes_from_hhmm('23:20')).toBe 23*60 + 20
