(function() {
  $(function() {
    var logo_canonical_url, logo_home_link;
    logo_canonical_url = window.location.origin;
    logo_home_link = logo_canonical_url.length > 1 ? logo_canonical_url : '/';
    return $('.logo.widget').attr('href', logo_home_link);
  });

}).call(this);
