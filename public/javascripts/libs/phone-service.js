var phoneNumber;

phoneNumber = (function() {
  function phoneNumber(phoneOptions) {
    var client_urn, location_urn;
    $(".p-tel").css("visibility", "hidden");
    client_urn = phoneOptions["clientUrn"].replace(/^g5-c-/, "g5-cpns-");
    location_urn = phoneOptions["locationUrn"];
    if (client_urn && location_urn) {
      this.getPhoneNumber(client_urn, location_urn);
    }
    $(".p-tel").css("visibility", "visible");
  }

  phoneNumber.prototype.getPhoneNumber = function(client_urn, location_urn) {
    var row_id;
    row_id = "#" + location_urn;
    return $.get("https://" + client_urn + ".herokuapp.com", function(data) {
      var $data, formattedPhone, numbers, phone, screen;
      $data = $(data);
      numbers = $data.find(row_id);
      screen = document.documentElement.clientWidth;
      phone = void 0;
      if (localStorage["ppc"]) {
        phone = $.trim(numbers.find(".p-tel-ppc").text());
      } else if (screen < 768) {
        phone = $.trim(numbers.find(".p-tel-mobile").text());
      } else {
        phone = $.trim(numbers.find(".p-tel-default").text());
      }
      if (phone != '') {
        formattedPhone = phone.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
        return $(".phone .number").attr("href", "tel://" + phone).find(".p-tel").html(formattedPhone);
      }
    });
  };

  return phoneNumber;

})();
