setUpContactInfoSheet = ->

  phoneOptions = JSON.parse($('.contact-info-sheet .config:first').html())
  new phoneNumber(phoneOptions)

  setFadeDelay = (seconds) ->
    delay = if seconds == "" then 4 else parseInt(seconds)
    $(document).idle({
      onIdle: ->
        $(".contact-info-sheet").fadeOut(420) unless $(".contact-info-sheet.opened").length
      onActive: ->
        $(".contact-info-sheet").fadeIn(420) unless noStickyNavForIE9?
      idle: delay * 1000
      events: 'mousemove keypress mousedonw scroll orientationchange'
    })

  setFadeDelay(phoneOptions.fadeDelay) 

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
    widget = $(".contact-info-sheet").first().addClass('mobile')
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
    $(".contact-info-sheet").off "click", ".info-sheet-page-up"
    $(".contact-info-sheet").off "click", ".info-sheet-page-down"
    widget = $(".contact-info-sheet").first().addClass('mobile')
    widgetHeight = widget.outerHeight()
    $("body").css "padding-bottom", widgetHeight

  if Modernizr.mq("(min-width: 668px)")
    initializeContactInfoSheet()

  else
    setupMobileContactInfoSheet()

  $(window).smartresize ->

    if Modernizr.mq("(min-width: 668px)")

      # If switching from mobile view to larger view, initialize widget
      if ($('.contact-info-sheet').first().hasClass('mobile'))
        $('.contact-info-sheet').first().removeClass('mobile')
        initializeContactInfoSheet()
      else
        # Otherwise just run setup to reposition / resize
        setupContactInfoSheet()
    else
      # If going from large to mobile size, turn off click handlers
      stopContactInfoSheet()


$ ->
  if typeof noStickyNavForIE9 != 'undefined'
    $('.contact-info-sheet').remove()
  else
    $('.contact-info-sheet').removeClass('hidden')
    setUpContactInfoSheet()