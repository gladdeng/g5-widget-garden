(function() {
  $(function() {
    var client_name, client_urn, location_name, location_urn, row_id;
    alert('wtf?');
    $(".p-tel").css("visibility", "hidden");
    client_urn = "6bqypn2";
    client_name = "farmhouse";
    location_urn = "6bqypn2";
    location_name = "hollywood";
    row_id = "#" + location_urn + "-" + location_name;
    return $.get("http://g5-cpns-" + client_urn + "-" + client_name + ".herokuapp.com", function(data) {
      var $data, numbers, phone, screen;
      $data = $(data);
      numbers = $data.find(row_id);
      screen = document.documentElement.clientWidth;
      phone = void 0;
      if (localStorage["ppc"]) {
        phone = numbers.find(".p-tel-ppc").val();
      } else if (screen < 768) {
        phone = numbers.find(".p-tel-mobile").val();
      } else {
        phone = numbers.find(".p-tel-default").val();
      }
      $(".phone.widget").attr("href", "tel://" + phone).find(".p-tel").html(phone.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3"));
      return $(".p-tel").css("visibility", "visible");
    });
  });

}).call(this);
