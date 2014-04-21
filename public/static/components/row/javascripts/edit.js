(function() {
  var chooseLayout, selectedLayout;

  chooseLayout = $(".select-row-layout");

  selectedLayout = chooseLayout.val();

  $('.col-widgets').hide();

  $('.' + selectedLayout).show();

  chooseLayout.on('change', function() {
    selectedLayout = $(this).val();
    $('.col-widgets').hide();
    return $('.' + selectedLayout).show();
  });

}).call(this);
