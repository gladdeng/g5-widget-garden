(function() {
  $(function() {
    var path;
    path = location.pathname;
    return $('[role=banner] .navigation a[href="' + path + '"]').addClass('active');
  });

}).call(this);
