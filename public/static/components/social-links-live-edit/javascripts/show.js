(function() {
  $(function() {
    var inputs;
    inputs = $(".edit-social-links-widget").find("input");
    return $.each(inputs, function() {
      if ($(this).value === "") {
        return $(this).addClass("empty");
      }
    });
  });

}).call(this);
