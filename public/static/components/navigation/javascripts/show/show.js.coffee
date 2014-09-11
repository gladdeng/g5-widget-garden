setMenuHeight = ->
  $("#drop-target-nav .navigation").css maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"

$ ->
  path = location.pathname.match(/([^\/]*)\/*$/)[1]
  $('[role=banner] .navigation a[href$="/' + path + '"]').addClass('active')

  setMenuHeight()

  $(window).smartresize ->
    setMenuHeight()