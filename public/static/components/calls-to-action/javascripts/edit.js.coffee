class window.UniqueSelectValues
  constructor: (@selects) ->
    @disableOptions()
    @selects.change(=> @disableOptions())

  disableOptions: ->
    @enableAll()
    @makeDisabled select for select in @selects when select.value isnt ''

  enableAll: ->
    for option in @selects.children() when option.disabled
      $(option).removeAttr('disabled')

  makeDisabled: (select) ->
    options = @selects.not(select).children("[value='#{select.value}']")
    options.attr('disabled','disabled')


