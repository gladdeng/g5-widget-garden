(function() {
  var setMenuHeight;

  setMenuHeight = function() {
    return $("#drop-target-nav .navigation").css({
      maxHeight: $(window).height() - $("header[role=banner] .collapsable-btn").outerHeight(true) + "px"
    });
  };

  $(function() {
    var path;
    path = location.pathname.match(/([^\/]*)\/*$/)[1];
    $('[role=banner] .navigation a[href$="/' + path + '"]').addClass('active');
    setMenuHeight();
    return $(window).smartresize(function() {
      return setMenuHeight();
    });
  });

}).call(this);
