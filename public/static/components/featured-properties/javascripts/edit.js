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
    var galleryOptions, index, markup, photo, photoMarkup, _i, _len, _ref;
    galleryOptions = JSON.parse($('.featured-properties-config').html());
    markup = "";
    _ref = galleryOptions.photos;
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      photo = _ref[index];
      photoMarkup = new inputFields(photo);
      markup += photoMarkup.markup();
    }
    return $('.photo-fields').append(markup);
  });

}).call(this);
