(function() {
  $(function() {
    var client_urn, location_urn, phoneOptions, row_id;
    phoneOptions = JSON.parse($('#phone-number-config:first').html());
    client_urn = phoneOptions["clientUrn"];
    location_urn = phoneOptions["locationUrn"];
    if (client_urn && location_urn) {
      $(".p-tel").css("visibility", "hidden");
      row_id = "#" + location_urn;
      return $.get("http://g5-cpns-" + client_urn + ".herokuapp.com", function(data) {
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
    }
  });

}).call(this);
