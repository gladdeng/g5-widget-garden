NAVIGATION =
  menu: $("#drop-target-nav .navigation")

  setMenuHeight: ->
    @menu.css maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"

  path: location.pathname.match(/([^\/]*)\/*$/)[1]

  setupSubNav: ->
    $('.has-subnav > a').on 'click', (e) ->
      NAVIGATION.menu.find('.subnav').removeClass 'show-subnav'

      if !$this.next().hasClass 'show-subnav'
        $(this).next().addClass 'show-subnav'

      return false

  closeSubNav: ->
    @menu.find('.show-subnav').removeClass 'show-subnav'

$ ->

  NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass "active"
  NAVIGATION.setMenuHeight()

  if $('.has-subnav').length > 0
    NAVIGATION.setupSubNav()

    $('body').on 'click', (e) ->
      NAVIGATION.closeSubNav()

  $(window).smartresize ->
    NAVIGATION.setMenuHeight()
