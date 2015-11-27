$.fn.extend
  showIf: (condition) -> if condition then @show() else @hide()

window.$e = (id) -> document.getElementById(id)
