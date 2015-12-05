#= require jquery/dist/jquery.min
#= require underscore/underscore-min
#= require fastclick/lib/fastclick
#= require react/react.min
#= require react/react-dom.min
#= require react-router/umd/ReactRouter.min
#= require history/umd/History.min

@UI = {}
{@Link} = ReactRouter

@defineComponent = (name, definition) ->
  definition.displayName ?= name
  window["C#{name}"] = React.createClass(definition)
