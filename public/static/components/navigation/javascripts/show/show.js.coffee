NAVIGATION =
  menu: $("#drop-target-nav .navigation")

  setMenuHeight: ->
    @menu.css maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"

  path: location.pathname.match(/([^\/]*)\/*$/)[1]

  setupSubNav: ->
    $('.has-subnav > a').on 'click', (e) ->

      NAVIGATION.menu.find('.subnav').not($(this).next()).removeClass 'show-subnav'
      $(this).next().toggleClass 'show-subnav'

      return false

  closeSubNav: ->
    @menu.find('.show-subnav').removeClass 'show-subnav'

  trackNavEvents: (navItem) ->
    try ga('send','event', 'Nav', 'Clicked', navItem.text()) catch err then

$ ->

  NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass "active"
  NAVIGATION.setMenuHeight()

  $('ul.top-nav').find('a').on "click", ->
    NAVIGATION.trackNavEvents $(this)

  if $('.has-subnav').length > 0
    NAVIGATION.setupSubNav()

    $('body').on 'click', (e) ->
      NAVIGATION.closeSubNav()

  $(window).smartresize ->
    NAVIGATION.setMenuHeight()
