(function() {
  var localPath;

  $(".footer-info #current-year").html(new Date().getFullYear());

  if ($(".social-links.widget").length < 1) {
    localPath = window.location.href;
<<<<<<< HEAD
=======
    if (window.location.hash) {
      localPath = localPath.replace(window.location.hash, '');
    }
>>>>>>> master
    $.each($(".social-links use"), function() {
      $(this).attr("xlink:href", localPath + $(this).attr("xlink:href"));
    });
  }

}).call(this);
