(function() {
  $(function() {
    var path;
    path = location.pathname.match(/([^\/]*)\/*$/)[1];
    return $('[role=banner] .navigation a[href*="/' + path + '"]').addClass('active');
  });

}).call(this);
