class clientLeadsService
  constructor: (clientUrn) ->

    heroku_app_name_max_length = 30

    cls_urn = clientUrn["clientUrn"].replace(/-c-/, "-cls-")
    cls_urn = cls_urn.substring(0, heroku_app_name_max_length)
    domain = "herokuapp.com"

    if cls_urn != ""
      @formSubmitAction(cls_urn, domain)

  formSubmitAction: (cls_urn, domain) ->
    clientLeadsUrl = "http://" + cls_urn + "." + domain + "/html_forms";

    $('.g5-enhanced-form form').attr("action", clientLeadsUrl)

$ ->
  clientUrn = JSON.parse($('.g5-enhanced-form .config:first').html())
  new clientLeadsService(clientUrn)
