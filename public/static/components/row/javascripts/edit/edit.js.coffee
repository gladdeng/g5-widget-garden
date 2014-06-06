$ ->
  widgetsDiv = $(".col-widgets:first")
  i = $("#p_scents p").size() + 1
  $("#addScnt").live "click", ->
    $("<p><label for=\"p_scnts\"><input type=\"text\" id=\"p_scnt\" size=\"20\" name=\"p_scnt_" + i + "\" value=\"\" placeholder=\"Input Value\" /></label> <a href=\"#\" id=\"remScnt\">Remove</a></p>").appendTo scntDiv
    i++
    false

  $("#remScnt").live "click", ->
    if i > 2
      $(this).parents("p").remove()
      i--
    false

  return

rowLayoutSelector = $("select .row-layout")
selectedLayout = rowLayoutSelector.val()

$('.' + selectedLayout).show()

rowLayoutSelector.on 'change', ->
  selectedLayout = $(this).val()
  $('.col-widgets').hide()
  $('.' + selectedLayout).show()

class EditWidgetModal
  constructor: (@widgetId) ->

  getEditForm: ->
    callback = (response) => @openModal response
    $.get @editURL(), {}, callback, "json"

  openModal: (response) ->
    $('#modal .modal-body').html(response["html"])
    if($('#ckeditor').length >= 1)
      CKEDITOR.replace('ckeditor')
    $('#modal').modal()
    $('.modal-body .edit_widget').submit =>
      if($('#ckeditor').length >= 1)
        $('#ckeditor').val(CKEDITOR.instances.ckeditor.getData())
      @saveEditForm()
      false
    false

  editURL: ->
    '/widgets/' + @widgetId + "/edit"

  #  Submits the widget configuration to the widget controller
  saveEditForm: ->
    $.ajax {
      url: $('.modal-body .edit_widget').prop('action'),
      type: 'PUT',
      dataType: 'json',
      data: $('.modal-body .edit_widget').serialize(),
      # Hide the configuration form if the request is successful
      success: =>
        $('#modal').modal('hide')
        url = $('.preview iframe').prop('src')
        $('iframe').prop('src', url)
      error: (xhr) =>
        # This is/was needed because of a bug in jQuery, it's actually successful
        if xhr.status == 204
          $('#modal').modal('hide')
        # Add validation errors
        else if xhr.responseText.length
          this.insertErrorMessages($.parseJSON(xhr.responseText))
        # Add server errors
        else
          this.insertErrorMessages({errors: {base: ["There was a problem saving the widget"]}})
    }

  insertErrorMessages: (errors) ->
    error = "<div class=\"alert alert-error\">" +
      errors["errors"]["base"][0] +
      "</div>"
    $('#modal .modal-body').prepend error

$(".edit-widget").on 'click', ->
  widgetId = $(this).data("widget-id")
  editWidgetModal = new EditWidgetModal(widgetId)
  editWidgetModal.getEditForm()
