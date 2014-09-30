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
        var $this, open;
        $this = $(this);
        open = $this.next().hasClass('show-subnav');
        NAVIGATION.menu.find('.subnav').removeClass('show-subnav');
        if (!open) {
          $this.next().addClass('show-subnav');
        }
        return false;
      });
    },
    closeSubNav: function() {
      return this.menu.find('.show-subnav').removeClass('show-subnav');
    }
  };

  $(function() {
    NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass("active");
    NAVIGATION.setMenuHeight();
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
