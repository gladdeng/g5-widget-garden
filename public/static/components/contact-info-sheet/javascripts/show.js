(function() {
  $(function() {
    var initializeContactInfoSheet, setupContactInfoSheet, setupMobileContactInfoSheet, showEmail, showPhone, stopContactInfoSheet;
    $('.contact-info-sheet').load(function() {
      var phoneOptions;
      phoneOptions = JSON.parse($('.contact-info-sheet .config:first').html());
      return new phoneNumber(phoneOptions);
    });
    showPhone = function(widget) {
      widget.removeClass("opened showing-email");
      widget.find(".info-sheet-email").hide();
      widget.find(".info-sheet-phone").show();
      return widget.addClass("opened showing-phone");
    };
    showEmail = function(widget) {
      widget.removeClass("opened showing-phone");
      widget.find(".info-sheet-phone").hide();
      widget.find(".info-sheet-email").show();
      return widget.addClass("opened showing-email");
    };
    setupContactInfoSheet = function() {
      var screenHeight, widget, widgetHeight, widgetPosition;
      $("body").css("padding-bottom", 0);
      widget = $(".contact-info-sheet").first();
      screenHeight = $(window).height();
      if ($("body").hasClass("web-home-template") || Modernizr.mq("(min-width: 1325px)")) {
        widgetPosition = $("header[role=banner]").outerHeight() + 30;
      } else {
        widgetPosition = $("header[role=banner]").outerHeight() + $("section[role=main] .row:first-of-type").outerHeight() + 30;
      }
      widgetHeight = screenHeight - widgetPosition;
      return widget.css("top", widgetPosition).find(".info-sheet-content").css("max-height", widgetHeight);
    };
    setupMobileContactInfoSheet = function() {
      var widget, widgetHeight;
      widget = $(".contact-info-sheet").first();
      widgetHeight = widget.outerHeight();
      return $("body").css("padding-bottom", widgetHeight);
    };
    initializeContactInfoSheet = function() {
      var screenHeight;
      setupContactInfoSheet();
      $(".contact-info-sheet").on("click", ".info-sheet-toggle", function(e) {
        var $this, widget;
        $this = $(this);
        widget = $(this).parent().parent();
        widget.find(".info-sheet-toggle").removeClass("active");
        if ($(this).hasClass("info-sheet-phone-btn")) {
          if (widget.hasClass("showing-phone")) {
            widget.removeClass("opened showing-phone");
          } else {
            showPhone(widget);
            $this.addClass("active");
          }
        } else {
          if (widget.hasClass("showing-email")) {
            widget.removeClass("opened showing-email");
          } else {
            showEmail(widget);
            $this.addClass("active");
          }
        }
        return false;
      });
      $(".contact-info-sheet").on("click", "form", function(e) {
        return e.stopPropagation();
      });
      $("html").on("click", function(e) {
        return $(".contact-info-sheet").removeClass("opened").find(".info-sheet-toggle").removeClass("active");
      });
      if ($("body").hasClass("web-home-template")) {
        screenHeight = $(window).height();
        $(".contact-info-sheet").on("click", ".info-sheet-page-up", function() {
          var scrollAmount, scrollPosition;
          scrollPosition = $(window).scrollTop();
          scrollAmount = scrollPosition - screenHeight;
          return $("html, body").animate({
            scrollTop: scrollAmount
          }, 1000);
        });
        return $(".contact-info-sheet").on("click", ".info-sheet-page-down", function() {
          var scrollAmount, scrollPosition;
          scrollPosition = $(window).scrollTop();
          scrollAmount = scrollPosition + screenHeight;
          return $("html, body").animate({
            scrollTop: scrollAmount
          }, 1000);
        });
      }
    };
    stopContactInfoSheet = function() {
      setupMobileContactInfoSheet();
      $(".contact-info-sheet").off("click", ".info-sheet-toggle").removeClass("opened showing-email showing=phone").removeAttr("style");
      $(".contact-info-sheet").on("click", ".info-sheet-page-up");
      return $(".contact-info-sheet").on("click", ".info-sheet-page-down");
    };
    return $(Modernizr).load(function() {
      if (Modernizr.mq("(min-width: 39.0626em)")) {
        initializeContactInfoSheet();
      } else {
        setupMobileContactInfoSheet();
      }
      return $(window).smartresize(function() {
        if (Modernizr.mq("(min-width: 39.0626em)")) {
          return initializeContactInfoSheet();
        } else {
          return stopContactInfoSheet();
        }
      });
    });
  });

}).call(this);
