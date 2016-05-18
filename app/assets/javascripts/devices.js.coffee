pending = []

getFriendlyParamNames = (params, nameIndex = -1) ->
  shortNames = []
  for n in params
    if nameIndex >= 0
      sp = n[nameIndex].split('.')
    else
      sp = n.split('.')
    shortNames.push(sp[sp.length - 1])

  return shortNames.join(', ')

getTaskFriendlyName = (task) ->
  switch task.name
    when 'getParameterValues'
      return "Refresh #{getFriendlyParamNames(task.parameterNames)}"
    when 'setParameterValues'
      return "Edit #{getFriendlyParamNames(task.parameterValues, 0)}"
    when 'reboot'
      return 'Reboot'
    when 'factoryReset'
      return 'Factory reset'
    when 'download'
      return "Push file (#{task.filename})"
    when 'addObject'
      return "Add to #{getFriendlyParamNames([task.objectName])}"
    when 'deleteObject'
      return "Delete #{getFriendlyParamNames([task.objectName])}"
    when 'refreshObject'
      return "Refresh #{getFriendlyParamNames([task.objectName])}"

  return task.name

submitUpdate = (type, data) ->
  form = $("""
    <form method="post">
      <input type="hidden" name="authenticity_token" value="#{$('meta[name=csrf-token]').attr('content')}" />
      <input type="hidden" name="#{type}" value='#{JSON.stringify(data)}' />
    </form>
  """)
  $('body').append(form)
  $(form).submit()

window.refreshSummary = (parameters) ->
  submitUpdate('refresh_summary', parameters)

window.refreshPending = () ->
  if pending.length == 0
    $('#pending').hide()
    return

  el = $('#pending ul')
  el.html('')
  $('#pending').fadeIn(200)
  $('#pending input[type="hidden"]').remove()
  $('#pending form').append("<input type='hidden' name='tasks' value='#{JSON.stringify(pending)}' />")

  for i in pending
    cls = ""
    if i.name == 'setParameterValues'
      cls = ' class="red"'
    else if i.name == 'reboot'
      cls = ' class="yellow"'
    else if i.name == 'factoryReset'
      cls = ' class="red"'
    else if i.name == 'download'
      cls = ' class="red"'
    el.append("<li#{cls}>#{getTaskFriendlyName(i)}</li>")


window.addPending = (task) ->
  pending.push(task)
  refreshPending()

window.getPending = () ->
  pending

window.clearPending = () ->
  pending = []
  window.refreshPending();

window.commitPending = () ->
  submitUpdate('commit', pending)

window.refreshParam = (paramName) ->
  task = {}
  task.name = 'getParameterValues'
  task.parameterNames = [paramName]
  addPending(task)

window.refreshObject = (objectName) ->
  task = {}
  task.name = 'refreshObject'
  task.objectName = objectName
  addPending(task)

window.addObject = (objectName) ->
  task = {}
  task.name = 'addObject'
  task.objectName = objectName
  addPending(task)

window.deleteObject = (objectName) ->
  task = {}
  task.name = 'deleteObject'
  task.objectName = objectName
  addPending(task)

window.reboot = () ->
  task = {}
  task.name = 'reboot'
  addPending(task)

window.factoryReset = () ->
  task = {}
  task.name = 'factoryReset'
  addPending(task)

window.pushFile = (file_id, filename) ->
  task = {}
  task.name = 'download'
  task.file = file_id
  task.filename = filename
  addPending(task)

window.editParam = (paramName, paramType, defaultValue, options) ->
  prompt(paramName, paramType, defaultValue, options, (val) ->
    return if val == null
    task = {}
    task.name = 'setParameterValues'
    task.parameterValues = [[paramName, val]]
    addPending(task)
  )

window.addTag = () ->
  tag = window.prompt('Enter new tag:').trim()
  if tag
    submitUpdate('add_tag', tag)

window.removeTag = (tag) ->
  submitUpdate('remove_tag', tag)

window.pingDevice = (ip) ->
  if !ip or ip == '(null)'
    alert('No IP address')
    return

  $.get("/ping/#{ip}", (data) ->
    alert(data)
  ).fail(() ->
    alert('Device is offline')
  )

window.sort = (container, param) ->
  f = $("##{container}")
  sort_param = f.children('input[name=sort]').attr('value')
  reverse = false
  if sort_param.substr(0, 1) == '-'
    sort_param = sort_param.substr(1)
    reverse = true

  if sort_param == param and not reverse
    f.children('input[name=sort]').attr('value', "-#{param}")
  else
    f.children('input[name=sort]').attr('value', param)

  f.submit()

prompt = (paramName, paramType, defaultValue, options, callback) ->
  modalWrapper = $('<div class="modal-wrapper"></div>')
  $('body').append(modalWrapper)

  modal = $('<div class="modal"></div>')
  modalWrapper.append(modal)

  modal.append("<p><strong>Editing</strong> <i>#{paramName}</i></p>")
  if options?.description?
    modal.append("<p>#{options.description}</p>")

  switch paramType
    when 'xsd:boolean'
      input = $('<select><option value="true">true</option><option value="false">false</option></select>')
      input.val(String(defaultValue))
    when 'xsd:int', 'xsd:unsignedInt'
      input = $("<input type=\"number\" value=\"#{defaultValue}\"/>")
    else
      if options?.options?
        input = $('<select>' + ("<option value='#{o}'>#{o}</option>" for o in options.options).join('') + '</select>')
      else
        input = $("<input type=\"text\" value=\"#{defaultValue}\"/>")
      input.val(defaultValue)

  modal.append(input)
  input.focus().select()

  buttons = $('<div class="buttons"></div>')
  modal.append(buttons)

  ok = $('<a href="#" class="button">OK</a>').click(() ->
    modalWrapper.remove()
    switch paramType
      when 'xsd:boolean'
        val = input.val() == 'true'
      when 'xsd:int', 'xsd:unsignedInt'
        val = parseInt(input.val())
      else
        val = input.val().trim()

    callback(val)
    return false
  )

  cancel = $('<a href="#">Cancel</a>').click(() ->
    modalWrapper.remove()
    callback(null)
    return false
  )

  buttons.append(ok).append(' ').append(cancel)
  return false


selectText = (container) ->
  if document.selection
    range = document.body.createTextRange()
    range.moveToElementText(container)
    range.select()
  else if window.getSelection
    range = document.createRange()
    range.selectNode(container);
    window.getSelection().addRange(range)


window.showLongValue = (container) ->
  if container.outerWidth() == container[0].scrollWidth or container[0].scrollWidth == 0
    selectText(container.get(0))
    return

  modalWrapper = $('<div class="modal-wrapper"></div>')
  $('body').append(modalWrapper)

  modal = $('<div class="modal long-value-modal"></div>')
  modalWrapper.append(modal)

  valueContainer = $("<textarea readonly=\"readonly\" cols=80>#{container.text()}</textarea>")

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
  return false


$(document).keydown((e) ->
  if e.keyCode == 27
    $('.modal-wrapper').remove()
)

$(document).on('mousedown', '.param-value, .param-path', null, (event) ->
  event.stopPropagation()
  $(document).on('mouseup mousemove', '.param-value, .param-path', null, handler = (event) ->
    $(document).off('mouseup mousemove', '.param-value, .param-path', handler)
    if event.type == 'mouseup'
      showLongValue($(this))
  )
)

$(document).on('click', '.modal-wrapper', null, (e) ->
  if( e.target != this )
       return false;

  $(this).remove()
)
