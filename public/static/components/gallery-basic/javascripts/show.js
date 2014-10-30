(function() {
  $(function() {
    return setInterval((function() {
      var $active, $next;
      $active = $(".gallery-basic .active");
      $next = ($active.next().length > 0 ? $active.next() : $(".gallery-basic figure:first"));
      $next.css("z-index", 2);
      return $active.fadeOut(1500, function() {
        $active.css("z-index", 1).show().removeClass("active");
        return $next.css("z-index", 3).addClass("active");
      });
    }), 7000);
  });

}).call(this);
