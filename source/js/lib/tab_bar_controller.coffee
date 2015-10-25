class @TabBarController
  constructor: (@tab_controllers, current_controller_index = 0) ->
    @current_controller = @tab_controllers[current_controller_index]
    @tab_scroll_offsets = {}
    @open @current_controller

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

  hide_tab_bar: ->
    $('#tabbar').hide()
    $('#container').addClass('no-tabbar')

  show_tab_bar: ->
    $('#tabbar').show()
    $('#container').removeClass('no-tabbar')
