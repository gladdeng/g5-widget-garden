(function() {
  var EditWidgetModal, chooseRowCount, selectedRowCount;

  chooseRowCount = $(".select-row-count");

  selectedRowCount = chooseRowCount.val();

  $('.row-widgets').hide();

  $('.' + selectedRowCount).show();

  chooseRowCount.on('change', function() {
    selectedRowCount = $(this).val();
    $('.row-widgets').hide();
    return $('.' + selectedRowCount).show();
  });

  EditWidgetModal = (function() {
    function EditWidgetModal(widgetId) {
      this.widgetId = widgetId;
    }

    EditWidgetModal.prototype.getEditForm = function() {
      var callback,
        _this = this;
      callback = function(response) {
        return _this.openModal(response);
      };
      return $.get(this.editURL(), {}, callback, "json");
    };

    EditWidgetModal.prototype.openModal = function(response) {
      var _this = this;
      $('#modal .modal-body').html(response["html"]);
      if ($('#ckeditor').length >= 1) {
        CKEDITOR.replace('ckeditor');
      }
      $('#modal').modal();
      $('.modal-body .edit_widget').submit(function() {
        if ($('#ckeditor').length >= 1) {
          $('#ckeditor').val(CKEDITOR.instances.ckeditor.getData());
        }
        _this.saveEditForm();
        return false;
      });
      return false;
    };

    EditWidgetModal.prototype.editURL = function() {
      return '/widgets/' + this.widgetId + "/edit";
    };

    EditWidgetModal.prototype.saveEditForm = function() {
      var _this = this;
      return $.ajax({
        url: $('.modal-body .edit_widget').prop('action'),
        type: 'PUT',
        dataType: 'json',
        data: $('.modal-body .edit_widget').serialize(),
        success: function() {
          var url;
          $('#modal').modal('hide');
          url = $('.preview iframe').prop('src');
          return $('iframe').prop('src', url);
        },
        error: function(xhr) {
          if (xhr.status === 204) {
            return $('#modal').modal('hide');
          } else if (xhr.responseText.length) {
            return _this.insertErrorMessages($.parseJSON(xhr.responseText));
          } else {
            return _this.insertErrorMessages({
              errors: {
                base: ["There was a problem saving the widget"]
              }
            });
          }
        }
      });
    };

    EditWidgetModal.prototype.insertErrorMessages = function(errors) {
      var error;
      error = "<div class=\"alert alert-error\">" + errors["errors"]["base"][0] + "</div>";
      return $('#modal .modal-body').prepend(error);
    };

    return EditWidgetModal;

  })();

  $(".edit-widget").on('click', function() {
    var editWidgetModal, widgetId;
    widgetId = $(this).data("widget-id");
    editWidgetModal = new EditWidgetModal(widgetId);
    return editWidgetModal.getEditForm();
  });

}).call(this);
