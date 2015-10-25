class @NavigationController
  constructor: (root_page_id) ->
    @pages = [root_page_id]
    @tab_key = root_page_id

  push: (page_id) ->
    page = $("##{page_id}")
    App.tabbar_controller.hide_tab_bar() if page.hasClass('no-tabbar')
    @pages.push(page_id)
    @update_view()

  pop: ->
    return unless @pages.length > 1
    App.tabbar_controller.show_tab_bar()
    @pages.pop()
    @update_view()

  update_view: ->
    App.open @current_page_id(), back_button: @pages.length > 1

  show: (options) ->
    App.open @current_page_id(), options

  current_page_id: ->
    @pages[ @pages.length - 1 ]

  @make_back_button: ->
    # $('<span>', class: 'icon back pe-7s-angle-left-circle')
    # $('<img>', class: 'back-button', src: 'images/icons/back.png', height: 20, width: 20)
    $('<img>', class: 'back-button', src: 'images/icons/custom_back.png', height: 20, width: 20)
