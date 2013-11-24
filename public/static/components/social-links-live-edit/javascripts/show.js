(function() {
  $(function() {
    var fields;
    fields = $(".edit-social-links-widget").find("input");
    return $.each(fields, function() {
      if ($(this).val() === "") {
        return $(this).addClass("empty");
      }
    });
  });

}).call(this);
