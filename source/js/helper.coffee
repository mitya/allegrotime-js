@Helper =
  minutes_from_hhmm: (string) ->
    components = string.split ":"
    hours   = parseInt components[0]
    minutes = parseInt components[1]
    hours * 60 + minutes

  minutes_since_midnight: ->
    now = new Date()
    midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0)
    ms_since_midnight = now.getTime() - midnight.getTime()
    Math.floor ms_since_midnight / 60 / 1000

  minutes_as_text: (totalMinutes) ->
    hours = totalMinutes // 60
    minutes = totalMinutes % 60

    hoursString = "#{hours} #{@pluralize_word_in_russian(hours, "час", "часа", "часов")}"
    minutesString = "#{minutes} #{@pluralize_word_in_russian(minutes, "минуту", "минуты", "минут")}"

    return minutesString if hours == 0
    return hoursString if minutes == 0
    "#{hoursString} #{minutesString}"

  # f(х, "час", "часа", "часов")
  # f(х, "минута", "минуты", "минут")
  pluralize_word_in_russian: (number, word1, word2, word5) ->
    rem100 = number % 100
    rem10 = number % 10

    return word5 if rem100 >= 11 && rem100 <= 19
    return word5 if rem10 == 0
    return word1 if rem10 == 1
    return word2 if rem10 >= 2 && rem10 <= 4
    return word5 if rem10 >= 5 && rem10 <= 9
    return word5

  pluralize_word_in_russian_with_number: (number, word1, word2, word5) ->
    number + ' ' + @pluralize_word_in_russian(number, word1, word2, word5)
