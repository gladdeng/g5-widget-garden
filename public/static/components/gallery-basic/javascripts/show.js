(function() {
  var nextImage;

  nextImage = function() {
    var $active, $img, $next, loading, src;
    $active = $(".gallery-basic .active");
    $next = ($active.next().length > 0 ? $active.next() : $(".gallery-basic figure:first"));
    loading = false;
    if ($next.hasClass("lazy-load")) {
      loading = true;
      $img = $next.find("img");
      src = $img.attr("data-src");
      $img.attr("src", src);
      $next.removeClass("lazy-load");
      $img.on('load', function() {
        return loading = false;
      });
    }
    if (loading === false) {
      $next.css("z-index", 2);
      return $active.fadeOut(1500, function() {
        $active.css("z-index", 1).show().removeClass("active");
        return $next.css("z-index", 3).addClass("active");
      });
    }
  };

  setInterval((function() {
    return nextImage();
  }), 7000);

}).call(this);
