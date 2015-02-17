(function() {
  $(function() {
    var photoRandomizerBuilder, photoRandomizerVars, photo_array, random_photo;
    photoRandomizerVars = photoRandomizerVarsConfig;
    photo_array = photoRandomizerVars.photos;
    random_photo = photo_array[Math.floor(Math.random() * photo_array.length)];
    photoRandomizerBuilder = function(data) {
      var photoRandomizerMarkup;
      if (data !== []) {
        photoRandomizerMarkup = "<img src=\"" + data.url + "\" alt=\"" + data.alt_text + "\"/>";
        return $('.photo-randomizer').append(photoRandomizerMarkup);
      }
    };
    return photoRandomizerBuilder(random_photo);
  });

}).call(this);
