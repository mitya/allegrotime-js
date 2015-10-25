$.fn.extend
  showIf: (condition) ->
    if condition then @show() else @hide()
