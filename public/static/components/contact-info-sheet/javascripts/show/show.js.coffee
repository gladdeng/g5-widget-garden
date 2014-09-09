$ ->

  

  balls = ->
    if document.getElementById('#tits')
      phoneOptions = JSON.parse($('.contact-info-sheet .config').html())
      new phoneNumber(phoneOptions)
    else
      setTimeout(balls(), 15)

  balls


  showPhone = (widget) ->
    widget.removeClass "opened showing-email"
    widget.find(".info-sheet-email").hide()
    widget.find(".info-sheet-phone").show()
    widget.addClass "opened showing-phone"


  showEmail = (widget) ->
    widget.removeClass "opened showing-phone"
    widget.find(".info-sheet-phone").hide()
    widget.find(".info-sheet-email").show()
    widget.addClass "opened showing-email"


  setupContactInfoSheet = ->
    $("body").css "padding-bottom", 0
    widget = $(".contact-info-sheet").first()
    screenHeight = $(window).height()

    if $("body").hasClass("web-home-template") or Modernizr.mq("(min-width: 1325px)")
      widgetPosition = $("header[role=banner]").outerHeight() + 30
    else
      widgetPosition = $("header[role=banner]").outerHeight() + $("section[role=main] .row:first-of-type").outerHeight() + 30

    widgetHeight = screenHeight - widgetPosition
    widget.css("top", widgetPosition).find(".info-sheet-content").css "max-height", widgetHeight


  setupMobileContactInfoSheet = ->
    widget = $(".contact-info-sheet").first()
    widgetHeight = widget.outerHeight()
    $("body").css "padding-bottom", widgetHeight


  initializeContactInfoSheet = ->
    setupContactInfoSheet()
    $(".contact-info-sheet").on "click", ".info-sheet-toggle", (e) ->
      $this = $(this)
      widget = $(this).parent().parent()
      widget.find(".info-sheet-toggle").removeClass "active"

      if $(this).hasClass("info-sheet-phone-btn")
        if widget.hasClass("showing-phone")
          widget.removeClass "opened showing-phone"
        else
          showPhone widget
          $this.addClass "active"

      else
        if widget.hasClass("showing-email")
          widget.removeClass "opened showing-email"
        else
          showEmail widget
          $this.addClass "active"
      false

    $(".contact-info-sheet").on "click", "form", (e) ->
      e.stopPropagation()

    $("html").on "click", (e) ->
      $(".contact-info-sheet").removeClass("opened").find(".info-sheet-toggle").removeClass "active"

    if $("body").hasClass("web-home-template")
      screenHeight = $(window).height()

      $(".contact-info-sheet").on "click", ".info-sheet-page-up", ->
        scrollPosition = $(window).scrollTop()
        scrollAmount = scrollPosition - screenHeight
        $("html, body").animate
          scrollTop: scrollAmount
        , 1000

      $(".contact-info-sheet").on "click", ".info-sheet-page-down", ->
        scrollPosition = $(window).scrollTop()
        scrollAmount = scrollPosition + screenHeight
        $("html, body").animate
          scrollTop: scrollAmount
        , 1000


  stopContactInfoSheet = ->
    setupMobileContactInfoSheet()
    $(".contact-info-sheet").off("click", ".info-sheet-toggle").removeClass("opened showing-email showing=phone").removeAttr "style"
    $(".contact-info-sheet").on "click", ".info-sheet-page-up"
    $(".contact-info-sheet").on "click", ".info-sheet-page-down"

  if Modernizr.mq("(min-width: 39.0626em)")
    initializeContactInfoSheet()

  else
    setupMobileContactInfoSheet()

  $(window).smartresize ->
    if Modernizr.mq("(min-width: 39.0626em)")
      initializeContactInfoSheet()
    else
      stopContactInfoSheet()
