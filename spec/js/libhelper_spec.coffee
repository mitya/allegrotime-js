describe 'Helper', ->
  it 'minutesFromHHMM', ->
    expect($U.minutesFromHHMM('12:45')).toBe 12*60 + 45
    expect($U.minutesFromHHMM('23:20')).toBe 23*60 + 20

  it 'pluralizeWordInRussian', ->
    expect($U.pluralizeWordInRussianWithNumber( 0, "час", "часа", "часов")).toBe '0 часов'
    expect($U.pluralizeWordInRussianWithNumber( 1, "час", "часа", "часов")).toBe '1 час'
    expect($U.pluralizeWordInRussianWithNumber( 2, "час", "часа", "часов")).toBe '2 часа'
    expect($U.pluralizeWordInRussianWithNumber( 3, "час", "часа", "часов")).toBe '3 часа'
    expect($U.pluralizeWordInRussianWithNumber( 5, "час", "часа", "часов")).toBe '5 часов'
    expect($U.pluralizeWordInRussianWithNumber( 8, "час", "часа", "часов")).toBe '8 часов'
    expect($U.pluralizeWordInRussianWithNumber(10, "час", "часа", "часов")).toBe '10 часов'
    expect($U.pluralizeWordInRussianWithNumber(15, "час", "часа", "часов")).toBe '15 часов'
    expect($U.pluralizeWordInRussianWithNumber(21, "час", "часа", "часов")).toBe '21 час'
    expect($U.pluralizeWordInRussianWithNumber(22, "час", "часа", "часов")).toBe '22 часа'
