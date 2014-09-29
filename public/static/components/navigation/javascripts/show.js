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
        $(this).next().toggleClass('show-subnav');
        return false;
      });
    }
  };

  $(function() {
    NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass("active");
    NAVIGATION.setMenuHeight();
    if ($('.has-subnav').length > 0) {
      NAVIGATION.setupSubNav();
    }
    return $(window).smartresize(function() {
      return NAVIGATION.setMenuHeight();
    });
  });

}).call(this);
