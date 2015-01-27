(function() {
  var localPath;

  $(".footer-info #current-year").html(new Date().getFullYear());

  if ($(".social-links.widget").length < 1) {
    localPath = window.location.href;
    $.each($(".social-links use"), function() {
      $(this).attr("xlink:href", localPath + $(this).attr("xlink:href"));
    });
  }

}).call(this);
