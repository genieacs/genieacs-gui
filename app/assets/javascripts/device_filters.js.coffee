isRegex = (input) ->
  /^\/(.*?)\/(g?i?m?y?)$/.test(input)

window.addFilter = (container, name, op = '', value = '', fade = true) ->
  type = typeof(value)
  if name of filters
    label = filters[name]
  else
    label = name
  html = """
  <div class="filter">
    <span _name="name" name="#{name}">#{label}</span>
    <select _name="op">
      <option value="" #{'selected' if op == ''}>=</options>
      <option value="$ne" #{'selected' if op == '$ne'}>&ne;</options>
      <option value="$lt" #{'selected' if op == '$lt'}>&lt;</options>
      <option value="$lte" #{'selected' if op == '$lte'}>&le;</options>
      <option value="$gt" #{'selected' if op == '$gt'}>&gt;</options>
      <option value="$gte" #{'selected' if op == '$gte'}>&ge;</options>
    </select>
    <input _name="value" type="#{type}" value="#{value}" />
    <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>
  """
  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.fadeOutAndRemove = (el) ->
  $(el).fadeOut(200, () ->
    $(this).remove()
  )


window.initFilters = (id) ->
  f = $("##{id}")
  container_selector = "##{id} > .filters_container"
  container = $(container_selector)

  recursive = (query) ->
    for q,v of query
      if q[0] == '$' # this is an operator
        if q != '$and' # only $and operator is supported
          throw new Error("The logical operator #{q} is not supported in precondition query.")
        recursive(v2) for v2 in v
      else if v instanceof Object
        for op,v2 of v
          addFilter(container, q, op, v2, false)
      else
        addFilter(container, q, '', v, false)

  recursive(JSON.parse(f.children('input[name=query]').attr('value')))

  popup = """
    <a href="#" class="action">&nbsp;+&nbsp;</a>
    <div class="popup">
  """
  for k,v of filters
    popup += """<a href="#" class="action" onclick="addFilter('#{container_selector}', '#{k}', '', '');return false;">#{v}</a><br/>"""

  popup += """
    </div>
  """
  f.children('.filter_selection').html(popup)


window.updateFilters = (id) ->
  query = {}
  params = {}
  $("##{id} > .filters_container").children().each( () ->
    name = $(this).children('[_name=name]').attr('name').trim()
    op = $(this).children('select').val().trim()
    value = $(this).children('input[_name="value"]').val().trim()
    type = $(this).children('input[_name="value"]').attr('type')
    if type == 'number'
      value = Number(value)

    if params[name]
      params[name].push([op, value])
    else
      params[name] = [[op, value]]
  )

  # builds a mongodb query in the shortest possible form
  for name,p of params
    if p.length > 1
      useAnd = false
      p.sort()
      for s, i in p
        if s[0] == '' or s[0] == p[i-1]?[0]
          useAnd = true
          break

      if useAnd
        query['$and'] = [] if not query['$and']?
        for s in p
          o = {}
          op = s[0]
          value = s[1]
          if op == ''
            o[name] = value
          else
            o[name] = {}
            o[name][op] = value
          query['$and'].push(o)
      else
        o = {}
        for s in p
          op = s[0]
          value = s[1]
          o[op] = value
        query[name] = o
    else
      op = p[0][0]
      value = p[0][1]
      if op != ''
        q = {}
        q[op] = value
        query[name] = q
      else
        query[name] = value

  $("##{id} > input[name=query]").attr('value', JSON.stringify(query))
  if $("##{id} > input[name=sort]").attr('value') == ''
    $("##{id} > input[name=sort]").attr('disabled', 'disabled')
  else
    $("##{id} > input[name=sort]").removeAttr('disabled')
