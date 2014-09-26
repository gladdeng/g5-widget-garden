NAVIGATION =
  menu: $("#drop-target-nav .navigation")

  setMenuHeight: ->
    @menu.css maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"

  path: location.pathname.match(/([^\/]*)\/*$/)[1]

  setupSubNav: ->
    $('.has-subnav > a').on 'click', (e) ->
      $(this).next().toggleClass 'show-subnav'
      return false

$ ->

  NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass "active"
  NAVIGATION.setMenuHeight()

  if $('.has-subnav').length > 0
    NAVIGATION.setupSubNav()

  $(window).smartresize ->
    NAVIGATION.setMenuHeight()
