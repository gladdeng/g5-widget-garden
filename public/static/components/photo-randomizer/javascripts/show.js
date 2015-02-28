(function() {
  $(function() {
    var cleanArray, photoRandomizerBuilder, photo_array, random_photo;
    photo_array = photoRandomizerVarsConfig.photos;
    cleanArray = [];
    photo_array.forEach(function(arrayItem) {
      var valuesExist, x, y;
      x = arrayItem.url;
      y = arrayItem.alt;
      valuesExist = x.length > 1 && y.length > 1 ? true : false;
      if (valuesExist === true) {
        cleanArray.push(arrayItem);
      }
    });
    random_photo = cleanArray[Math.floor(Math.random() * cleanArray.length)];
    photoRandomizerBuilder = function(data) {
      var photoRandomizerMarkup;
      if (data !== []) {
        photoRandomizerMarkup = "<img src=\"" + data.url + "\" alt=\"" + data.alt_text + "\"/>";
        return $('.photo-randomizer').append(photoRandomizerMarkup);
      }
    };
    if (cleanArray.length > 1) {
      return photoRandomizerBuilder(random_photo);
    }
  });

}).call(this);
