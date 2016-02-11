$.fn.extend
  showIf: (condition) -> if condition then @show() else @hide()

window.$e = (id) -> document.getElementById(id)

Function::prop = (name, getter) ->
  Object.defineProperty this::, name, get: getter

Function::cprop = (name, getter) ->
  Object.defineProperty this, name, get: getter
