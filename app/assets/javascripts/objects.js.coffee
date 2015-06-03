flattenObject = (object) ->
  newObj = {}
  f = (obj, prefix) ->
    for k, v of obj
      if Object.prototype.toString.call(v) == '[object Object]'
        f(v, "#{prefix}#{k}.")
      else
        newObj["#{prefix}#{k}"] = v
  f(object, '')
  return newObj


window.addParameter = (container, name = '', value = '', key = false) ->
  html = """<tr>
    <td>
      <input type="checkbox" _name="key" value="1" #{'checked' if key} />
    </td>
    <td>
      <input type="text" _name="parameter" value="#{name}" />
    </td>
    <td>
      <input type="text" _name="value" value="#{value}" />
    </td>
    <td>
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent().parent());return false;">&nbsp;x&nbsp;</a>
    </td>
    </tr>"""

  el = $(html)
  $(container).children('tbody:last').append(el)
  el.hide().fadeIn(300)


window.initObject = (id) ->
  f = $("##{id}")
  parameters = flattenObject(JSON.parse(f.children('input[name=parameters]').attr('value')))
  container_selector = "##{id} > .parameters_container"
  container = $(container_selector)

  for k,v of parameters
    continue if k[0] == '_'
    if parameters['_keys']?
      key = (parameters['_keys'].indexOf(k) != -1)
    addParameter(container, k, v, key)

  popup = """
    <a href="#" class="action" onclick="addParameter('#{container_selector}');return false;">&nbsp;+&nbsp;</a>
  """
  f.children('.parameters_selection').html(popup)


window.updateObject = (id) ->
  container_selector = "##{id} > .parameters_container tbody"
  object = {}
  keys = []
  $(container_selector).children().each( () ->
    key = $(this).find('input[_name="key"]').is(':checked')
    parameter = $(this).find('input[_name="parameter"]').val().trim()
    value = $(this).find('input[_name="value"]').val().trim()

    ref = object
    p = parameter.split('.')
    while p.length > 1
      ref = ref[p[0]] ?= {}
      p.shift()
    ref[p[0]] = value

    if key
      keys.push(parameter)
  )
  if keys.length > 0
    object['_keys'] = keys
  $("##{id} > input[name=parameters]").attr('value', JSON.stringify(object))
