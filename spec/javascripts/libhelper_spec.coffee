describe 'Helper', ->
  it 'minutes_from_hhmm', ->
    expect(Helper.minutes_from_hhmm('12:45')).toBe 12*60 + 45
    expect(Helper.minutes_from_hhmm('23:20')).toBe 23*60 + 20

  it 'pluralize_word_in_russian', ->
    expect(Helper.pluralize_word_in_russian_with_number( 0, "час", "часа", "часов")).toBe '0 часов'
    expect(Helper.pluralize_word_in_russian_with_number( 1, "час", "часа", "часов")).toBe '1 час'
    expect(Helper.pluralize_word_in_russian_with_number( 2, "час", "часа", "часов")).toBe '2 часа'
    expect(Helper.pluralize_word_in_russian_with_number( 3, "час", "часа", "часов")).toBe '3 часа'
    expect(Helper.pluralize_word_in_russian_with_number( 5, "час", "часа", "часов")).toBe '5 часов'
    expect(Helper.pluralize_word_in_russian_with_number( 8, "час", "часа", "часов")).toBe '8 часов'
    expect(Helper.pluralize_word_in_russian_with_number(10, "час", "часа", "часов")).toBe '10 часов'
    expect(Helper.pluralize_word_in_russian_with_number(15, "час", "часа", "часов")).toBe '15 часов'
    expect(Helper.pluralize_word_in_russian_with_number(21, "час", "часа", "часов")).toBe '21 час'
    expect(Helper.pluralize_word_in_russian_with_number(22, "час", "часа", "часов")).toBe '22 часа'
