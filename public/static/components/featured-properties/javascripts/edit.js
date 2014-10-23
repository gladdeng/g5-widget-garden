(function() {
  var inputFields;

  inputFields = (function() {
    function inputFields(photo) {
      this.photo = photo;
    }

    inputFields.prototype.markup = function() {
      return "<div>*** " + this.photo.url + " ***</div>";
    };

    return inputFields;

  })();

  $(function() {
    var galleryOptions;
    galleryOptions = JSON.parse($('.featured-properties-config').html());
    $('.photo-fields .form-field').hide();
    return $('.data-summary .hide-inputs, .data-summary .show-inputs, .data-summary img').click(function() {
      $(this).parent().siblings().slideToggle();
      return $(this).parent().find('.show-inputs, .hide-inputs').slideToggle();
    });
  });

}).call(this);
