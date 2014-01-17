(function() {
  var clientLeadsService;

  clientLeadsService = (function() {
    function clientLeadsService(clientUrn) {
      var cls_urn, domain, heroku_app_name_max_length;
      heroku_app_name_max_length = 30;
      cls_urn = clientUrn["clientUrn"].replace(/-c-/, "-cls-");
      cls_urn = cls_urn.substring(0, heroku_app_name_max_length);
      domain = "herokuapp.com";
      if (cls_urn !== "") {
        this.formSubmitAction(cls_urn, domain);
      }
    }

    clientLeadsService.prototype.formSubmitAction = function(cls_urn, domain) {
      var clientLeadsUrl;
      clientLeadsUrl = "http://" + cls_urn + "." + domain + "/html_form";
      return $('.g5-enhanced-form form').attr("action", clientLeadsUrl);
    };

    return clientLeadsService;

  })();

  $(function() {
    var clientUrn;
    clientUrn = JSON.parse($('.g5-enhanced-form .config:first').html());
    return new clientLeadsService(clientUrn);
  });

}).call(this);
