selectText = (container) ->
  if document.selection
    range = document.body.createTextRange()
    range.moveToElementText(container)
    range.select()
  else if window.getSelection
    range = document.createRange()
    range.selectNodeContents(container);
    window.getSelection().addRange(range)


getLongText = (container) ->
  if not container.hasClass('long-text-always') and
      container.outerWidth() == container[0].scrollWidth or container[0].scrollWidth == 0
    return null

  return container.text()


showLongText = (text) ->
  modalWrapper = $('<div class="modal-wrapper"></div>')
  $('body').append(modalWrapper)

  modal = $('<div class="modal long-value-modal"></div>')
  modalWrapper.append(modal)

  valueContainer = $("<textarea readonly=\"readonly\" cols=80>#{text}</textarea>")

  modal.append(valueContainer)

  buttons = $('<div class="buttons"></div>')
  modal.append(buttons)
  close = $('<a href="#">Close</a>').click(() ->
    modalWrapper.remove()
    return false
  )

  buttons.append(close)
  valueContainer.focus()
  valueContainer.select()


$(document).keydown((e) ->
  if e.keyCode == 27
    $('.modal-wrapper').remove()
)

$(document).on('mousedown', '.long-text, .long-text-always', null, (event) ->
  longText = getLongText($(this))

  if longText
    event.stopPropagation()

  $(document).on('mouseup mousemove', '.long-text, .long-text-always', null, handler = (event) ->
    $(document).off('mouseup mousemove', '.long-text, .long-text-always', handler)
    if event.type == 'mouseup'
      if longText
        showLongText(longText)
      else
        selectText(this)
  )
)

$(document).on('click', '.modal-wrapper', null, (e) ->
  if (e.target != this)
    return false;

  $(this).remove()
)
