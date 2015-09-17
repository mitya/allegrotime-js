DirectionToFinland = 1
DirectionToRussia = 2

class @Closing
  # props: rawTime, time, crossing, direction, trainTime

  closingTime: ->
    @trainTime - 10
    
  time: ->
    @timeVal ?= (
      hours = @trainTime / 60
      minutes = @trainTime.remainder(60)
      # "%i:%02i" % [hours, minutes]
      "#{hours}:#{minutes}"
    )
      
  toRussia: ->
    @direction == DirectionToRussia
  
  trainNumber: ->
    position = @crossing.closings.indexOf(this)
    780 + 1 + position
  
  directionCode: ->
    return "FIN" if @direction == DirectionToFinland
    return "RUS" if @direction == DirectionToRussia
    return "N/A"
      
  description: ->
    "Closing(#{@crossing.localizedName}, #{@time}, #{@directionCode})"
  
  state: ->
    @crossing.state
  
  isClosest: ->
    this == @crossing.currentClosing()
  
  color: ->
    @crossing.color()
    
  toTrackingKey: ->
    "#{@crossing.name}-#{@time}"
