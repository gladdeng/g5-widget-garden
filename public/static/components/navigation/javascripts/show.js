(function() {
  var NAVIGATION;

  NAVIGATION = {
    menu: $("#drop-target-nav .navigation"),
    setMenuHeight: function() {
      return this.menu.css({
        maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"
      });
    },
    path: location.pathname.match(/([^\/]*)\/*$/)[1],
    setupSubNav: function() {
      return $('.has-subnav > a').on('click', function(e) {
        NAVIGATION.menu.find('.subnav').not($(this).next()).removeClass('show-subnav');
        $(this).next().toggleClass('show-subnav');
        return false;
      });
    },
    closeSubNav: function() {
      return this.menu.find('.show-subnav').removeClass('show-subnav');
    },
    trackNavEvents: function(navItem) {
      var err;
      try {
        return ga('send', 'event', 'Nav', 'Clicked', navItem.text());
      } catch (_error) {
        err = _error;
      }
    }
  };

  $(function() {
    NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass("active");
    NAVIGATION.setMenuHeight();
    $('ul.top-nav').find('a').on("click", function() {
      return NAVIGATION.trackNavEvents($(this));
    });
    if ($('.has-subnav').length > 0) {
      NAVIGATION.setupSubNav();
      $('body').on('click', function(e) {
        return NAVIGATION.closeSubNav();
      });
    }
    return $(window).smartresize(function() {
      return NAVIGATION.setMenuHeight();
    });
  });

}).call(this);
