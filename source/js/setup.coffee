#= require jquery/dist/jquery
#= require underscore/underscore
#= require fastclick/lib/fastclick
#= require react/react
#= require react/react-dom
#= require react-router/umd/ReactRouter

@UI = {}
{@Link} = ReactRouter

@defineComponent = (name, definition) ->
  definition.displayName ?= name
  window["C#{name}"] = React.createClass(definition)
