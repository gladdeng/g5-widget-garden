$ ->
  phoneOptions = JSON.parse($('#phone-number-config:first').html())

  client_urn = phoneOptions["clientUrn"].replace(/^g5-c-/, "g5-cpns-")
  location_urn = phoneOptions["locationUrn"]

  if client_urn && location_urn
    $(".p-tel").css "visibility", "hidden"

    row_id = "#" + location_urn

    $.get "http://" + client_urn + ".herokuapp.com", (data) ->

      $data = $(data)
      numbers = $data.find(row_id)
      screen = document.documentElement.clientWidth
      phone = undefined

      if localStorage["ppc"]
        phone = numbers.find(".p-tel-ppc").val()
      else if screen < 768
        phone = numbers.find(".p-tel-mobile").val()
      else
        phone = numbers.find(".p-tel-default").val()

      $(".phone.widget").attr("href", "tel://" + phone).find(".p-tel").html phone.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3")
      $(".p-tel").css "visibility", "visible"
