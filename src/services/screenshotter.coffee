import Crossing from './crossing'

export bindScreenshots ->
  Crossing.setCurrent Crossing.get('Удельная')
  @actions = [
    ( => @tabbar_controller.open(@schedule_nav_controller) ),
    ( => @tabbar_controller.open(@status_nav_controller) ),
    ( => app.status_nav_controller.push('crossings') )
  ]

  # @actions = [
  #   ( => app.dispatch openTab('schedule') ),
  #   ( => history.pushState('/schedule') ),
  #   ( => app.dispatch openTab('status') )
  # ]

  $("body").on 'click', =>
    action = @actions.shift()
    action.call()
