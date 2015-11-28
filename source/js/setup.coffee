#= require jquery/dist/jquery
#= require underscore/underscore
#= require fastclick/lib/fastclick
#= require react/react
#= require react/react-dom
#= require react-router/umd/ReactRouter
#= require handlebars.runtime
#= require handlebar_helpers
#= require_tree ./templates

@UI = {}
@render = ReactDOM.render
{@Router, @Route, @IndexRoute, @Link} = ReactRouter

@defineComponent = (name, definition) ->
  definition.displayName ?= name
  @UI[name] = React.createClass(definition)
