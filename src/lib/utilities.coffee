export default Utilities =
  minutesFromHHMM: (string) ->
    components = string.split ":"
    hours   = parseInt components[0]
    minutes = parseInt components[1]
    hours * 60 + minutes

  minutesAsHHMM: (minutesSinceMidnight) ->
    hours = minutesSinceMidnight // 60
    hours = '0' + hours if hours < 10
    minutes = minutesSinceMidnight % 60
    minutes = '0' + minutes if minutes < 10
    "#{hours}:#{minutes}"

  minutesSinceMidnight: (now = $U.now()) ->
    midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0)
    ms_since_midnight = now.getTime() - midnight.getTime()
    Math.floor ms_since_midnight / 60 / 1000

  now: ->
    new Date
    # new Date('2015-11-15 15:45')

  currentHour: ->
    @now().getHours()

  formatDate: (date) ->
    "#{date.getDate()}.#{date.getMonth() + 1}.#{date.getFullYear() - 2000}"

  formatDateWithTime: (date) ->
    hours = date.getHours()
    minutes = date.getMinutes()
    minutes = '0' + minutes if minutes < 10
    "#{@formatDate(date)}, #{hours}:#{minutes}"

  minutesAsText: (totalMinutes) ->
    hours = totalMinutes // 60
    minutes = totalMinutes % 60

    hoursString = "#{hours} #{@pluralizeWordInRussian(hours, "час", "часа", "часов")}"
    minutesString = "#{minutes} #{@pluralizeWordInRussian(minutes, "минуту", "минуты", "минут")}"

    return minutesString if hours == 0
    return hoursString if minutes == 0
    "#{hoursString} #{minutesString}"

  # f(х, "час", "часа", "часов")
  # f(х, "минута", "минуты", "минут")
  pluralizeWordInRussian: (number, word1, word2, word5) ->
    rem100 = number % 100
    rem10 = number % 10

    return word5 if rem100 >= 11 && rem100 <= 19
    return word5 if rem10 == 0
    return word1 if rem10 == 1
    return word2 if rem10 >= 2 && rem10 <= 4
    return word5 if rem10 >= 5 && rem10 <= 9
    return word5

  pluralizeWordInRussianWithNumber: (number, word1, word2, word5) ->
    number + ' ' + @pluralizeWordInRussian(number, word1, word2, word5)

  distanceBetweenLatLngInKm: (lat1, lon1, lat2, lon2) ->
    R = 6371
    dLat = @deg2rad(lat2 - lat1)
    dLon = @deg2rad(lon2 - lon1)
    a =
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(@deg2rad(lat1)) * Math.cos(@deg2rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = R * c

  deg2rad: (deg) ->
    deg * Math.PI / 180

  formatCoords: (coords) ->
    "(#{coords.latitude.toFixed(5)}, #{coords.longitude.toFixed(5)})"

  log: ->
    console.debug.apply console, arguments
    message = [].join.apply arguments, [' ']
    $('#debug-info').append("#{message}<br>")

  times: {}

  time: (label) ->
    @times[label] = window.performance.now()

  timeEnd: (label) ->
    startTime = @times[label]
    delete @times[label]
    window.performance.now() - startTime

  printTimeEnd: (label) ->
    time = @timeEnd(label)
    @log("#{label}: #{time.toFixed(3)}")

  benchmarkMode: 'console'

  benchmark: (label, block) ->
    switch @benchmarkMode
      when 'console'
        console.time(label)
        block.call()
        console.timeEnd(label)
      when 'html'
        @time(label)
        block.call()
        @printTimeEnd(label)
      when 'production'
        block.call()

  cssClasses: (args...) ->
    args.filter(_.identity).join(' ')
