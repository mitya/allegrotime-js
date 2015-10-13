class @TabBarController
  constructor: (@tab_controllers) ->
    @current_controller = @tab_controllers[0]
    @tab_scroll_offsets = {}

  open: (tab_controller) ->
    @remember_page_scroll_top()
    @current_controller = tab_controller
    @update_tab_bar(tab_controller)
    tab_controller.show(animated: no)
    @restore_page_scroll_top()

  remember_page_scroll_top: ->
    @tab_scroll_offsets[@current_controller.tab_key] = $('body').scrollTop()

  restore_page_scroll_top: ->
    $('body').scrollTop @tab_scroll_offsets[@current_controller.tab_key]

  update_tab_bar: ->
    $("#tabbar .tab").removeClass('active').filter(".#{@current_controller.tab_key}").addClass('active')


class @NavigationController
  constructor: (root_page_id) ->
    @pages = [root_page_id]
    @tab_key = root_page_id

  push: (page_id) ->
    @pages.push(page_id)
    @update_view()

  pop: ->
    return unless @pages.length > 1
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
