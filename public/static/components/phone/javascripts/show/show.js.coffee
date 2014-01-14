class phoneNumber
  constructor: (phoneOptions) ->
    $(".p-tel").css "visibility", "hidden"

    client_urn = phoneOptions["clientUrn"].replace(/^g5-c-/, "g5-cpns-")
    location_urn = phoneOptions["locationUrn"]

    if client_urn && location_urn
      @getPhoneNumber(client_urn, location_urn)

    $(".p-tel").css "visibility", "visible"

  getPhoneNumber: (client_urn, location_urn) ->
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

      formattedPhone = phone.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3")

      $(".phone .number").attr("href", "tel://" + phone)
                        .find(".p-tel")
                        .html formattedPhone

$ ->
  phoneOptions = JSON.parse($('.phone .config:first').html())
  new phoneNumber(phoneOptions)
