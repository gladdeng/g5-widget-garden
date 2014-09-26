(function() {
  var NAVIGATION;

  NAVIGATION = {
    menu: $("#drop-target-nav .navigation"),
    setMenuHeight: function() {
      return this.menu.css({
        maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"
      });
    },
    path: location.pathname.match(/([^\/]*)\/*$/)[1]
  };

  $(function() {
    NAVIGATION.menu.find("a[href$=\"/" + NAVIGATION.path + "\"]").addClass("active");
    NAVIGATION.setMenuHeight();
    return $(window).smartresize(function() {
      return NAVIGATION.setMenuHeight();
    });
  });

}).call(this);
