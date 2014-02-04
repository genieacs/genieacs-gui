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

window.refreshSummary = () ->
  submitUpdate('refresh_summary', null)

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

window.editParam = (paramName, paramType, defaultValue) ->
  switch paramType
    when 'xsd:boolean'
      v = window.prompt("#{paramName} (Allowed: true, false)", defaultValue)
      return if v == null

      if v == 'true'
        val = true
      else if v == 'false'
        val = false
      else
        alert('Invalid value')
        return
    when 'xsd:int', 'xsd:unsignedInt'
      v = window.prompt("#{paramName} (Allowed: integer number)", defaultValue)
      return if v == null
      val = parseInt(v)
      if isNaN(val)
        alert('Invalid value')
        return
    when 'xsd:string'
      val = window.prompt("#{paramName}", defaultValue)
      return if val == null
    else
      return

  task = {}
  task.name = 'setParameterValues'
  task.parameterValues = [[paramName, val]]
  addPending(task)

window.addActions = () ->
  $("\#device-params li").each( (index) ->
    name = this.getAttribute('name')
    isWritable = parseInt(this.getAttribute('writable'))
    type = this.getAttribute('type')
    isObject = this.getAttribute('object')?
    isInstance = this.getAttribute('instance')?
    actions = ""

    if isObject
      if isWritable
        actions += "<a href=\"#\" onclick=\"addObject('#{name}');return false;\">Add</a>"
      actions += "<a href=\"#\" onclick=\"refreshObject('#{name}');return false;\">Refresh</a>"
    else if isInstance
      if isWritable
        actions += "<a href=\"#\" onclick=\"deleteObject('#{name}');return false;\">Delete</a>"
      actions += "<a href=\"#\" onclick=\"refreshObject('#{name}');return false;\">Refresh</a>"
    else
      if isWritable
        actions += "<a href=\"#\" onclick=\"editParam('#{name}', '#{type}');return false;\">Edit</a>"
      actions += "<a href=\"#\" onclick=\"refreshParam('#{name}');return false;\">Refresh</a>"

    $(this).prepend("<span class=\"actions\">#{actions}</span>")
  )

window.addTag = () ->
  tag = window.prompt('Enter new tag:')
  if tag
    submitUpdate('add_tag', tag)

window.removeTag = (tag) ->
  submitUpdate('remove_tag', tag)

window.pingDevice = (ip) ->
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
