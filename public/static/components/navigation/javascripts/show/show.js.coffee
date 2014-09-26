NAVIGATION =
  menu: $("#drop-target-nav .navigation")
  setMenuHeight: ->
    @menu.css maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"
  path: location.pathname.match(/([^\/]*)\/*$/)[1]

$ ->

  NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass "active"
  NAVIGATION.setMenuHeight()

  $(window).smartresize ->
    NAVIGATION.setMenuHeight()
