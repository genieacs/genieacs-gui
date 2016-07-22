window.addProvision = (container, name = '', args = [], fade = true) ->
  el = $('<div configurationType="provision">')
  el.append('Provision name: ')
  el.append($('<input/>', {type: 'text', _name: 'provision', value: name}))
  el.append(' Arguments: ')
  el.append($('<input/>', {type: 'text', _name: 'args', value: CSV.encode([args])}))
  el.append('<a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>')

  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addValueConfiguration = (container, name = '', value = '', fade = true) ->
  html = """<div configurationType="value">
      Set
      <input type="text" _name="name" value="#{name}" />
      to
      <input type="text" _name="value" value="#{value}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addAgeConfiguration = (container, name = '', age = '', fade = true) ->
  html = """<div configurationType="age">
      Refresh
      <input type="text" _name="name" value="#{name}" />
      every
      <input type="text" _name="age" value="#{age}" />
      seconds
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addCustomCommandValueConfiguration = (container, command = '', value = '', fade = true) ->
  html = """<div configurationType="custom_command_value">
      Command
      <input type="text" _name="command" value="#{command}" />
      Assert value
      <input type="text" _name="value" value="#{value}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addCustomCommandAgeConfiguration = (container, command = '', age = '', fade = true) ->
  html = """<div configurationType="custom_command_age">
      Execute
      <input type="text" _name="command" value="#{command}" />
      every
      <input type="text" _name="age" value="#{age}" />
      seconds
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addSoftwareVersionConfiguration = (container, softwareVersion = '', fade = true) ->
  html = """<div configurationType="software_version">
      Software version
      <input type="text" _name="software_version" value="#{softwareVersion}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addAddTagConfiguration = (container, tag = '', fade = true) ->
  html = """<div configurationType="add_tag">
      Add tag
      <input type="text" _name="tag" value="#{tag}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addRemoveTagConfiguration = (container, tag = '', fade = true) ->
  html = """<div configurationType="delete_tag">
      Remove tag
      <input type="text" _name="tag" value="#{tag}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addAddObjectConfiguration = (container, name = '', object = '', fade = true) ->
  html = """<div configurationType="add_object">
      Add object
      <input type="text" _name="object" value="#{object}" />
      to
      <input type="text" _name="name" value="#{name}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.addRemoveObjectConfiguration = (container, name = '', object = '', fade = true) ->
  html = """<div configurationType="delete_object">
      Remove object
      <input type="text" _name="object" value="#{object}" />
      from
      <input type="text" _name="name" value="#{name}" />
      <a href="#" class="action" onclick="fadeOutAndRemove($(this).parent());return false;">&nbsp;x&nbsp;</a>
    </div>"""

  el = $(html)
  $(container).append(el)
  el.hide().fadeIn(300) if fade


window.initConfigurations = (id) ->
  f = $("##{id}")
  configurations = JSON.parse(f.children('input[name=configurations]').attr('value'))
  container_selector = "##{id} > .configurations_container"
  container = $(container_selector)

  for c in configurations
    switch c['type']
      when 'value'
        addValueConfiguration(container_selector, c['name'], c['value'], false)
      when 'age'
        addAgeConfiguration(container_selector, c['name'], c['age'], false)
      when 'add_tag'
        addAddTagConfiguration(container_selector, c['tag'], false)
      when 'delete_tag'
        addRemoveTagConfiguration(container_selector, c['tag'], false)
      when 'add_object'
        addAddObjectConfiguration(container_selector, c['name'], c['object'], false)
      when 'delete_object'
        addRemoveObjectConfiguration(container_selector, c['name'], c['object'], false)
      when 'custom_command_value'
        addCustomCommandValueConfiguration(container_selector, c['command'], c['value'], false)
      when 'custom_command_age'
        addCustomCommandAgeConfiguration(container_selector, c['command'], c['age'], false)
      when 'software_version'
        addSoftwareVersionConfiguration(container_selector, c['software_version'], false)
      when 'provision'
        addProvision(container_selector, c['name'], c['args'], false)

  popup = """
    <a href="#" class="action">&nbsp;+&nbsp;</a>
    <div class="popup">
      <a href="#" class="action" onclick="addProvision('#{container_selector}');return false;">Provision</a><br/>
      <a href="#" class="action" onclick="addValueConfiguration('#{container_selector}');return false;">Set</a><br/>
      <a href="#" class="action" onclick="addAgeConfiguration('#{container_selector}');return false;">Refresh</a><br/>
      <a href="#" class="action" onclick="addAddTagConfiguration('#{container_selector}');return false;">Add tag</a><br/>
      <a href="#" class="action" onclick="addRemoveTagConfiguration('#{container_selector}');return false;">Remove tag</a><br/>
      <a href="#" class="action" onclick="addAddObjectConfiguration('#{container_selector}');return false;">Add object</a><br/>
      <a href="#" class="action" onclick="addRemoveObjectConfiguration('#{container_selector}');return false;">Remove object</a><br/>
      <a href="#" class="action" onclick="addCustomCommandValueConfiguration('#{container_selector}');return false;">Command value</a><br/>
      <a href="#" class="action" onclick="addCustomCommandAgeConfiguration('#{container_selector}');return false;">Command age</a><br/>
      <a href="#" class="action" onclick="addSoftwareVersionConfiguration('#{container_selector}');return false;">Software version</a><br/>
    </div>
  """
  f.children('.configurations_selection').html(popup)


window.updateConfigurations = (id) ->
  container_selector = "##{id} > .configurations_container"
  configurations = []
  $(container_selector).children().each( () ->
    type = this.getAttribute('configurationtype')
    switch type
      when 'value'
        name = $(this).children('input[_name="name"]').val().trim()
        value = $(this).children('input[_name="value"]').val().trim()
        configurations.push({type: 'value', name: name, value: value})
      when 'age'
        name = $(this).children('input[_name="name"]').val().trim()
        age = $(this).children('input[_name="age"]').val().trim()
        configurations.push({type: 'age', name: name, age: age})
      when 'add_tag'
        tag = $(this).children('input[_name="tag"]').val().trim()
        configurations.push({type: 'add_tag', tag: tag})
      when 'delete_tag'
        tag = $(this).children('input[_name="tag"]').val().trim()
        configurations.push({type: 'delete_tag', tag: tag})
      when 'add_object'
        name = $(this).children('input[_name="name"]').val().trim()
        object = $(this).children('input[_name="object"]').val().trim()
        configurations.push({type: 'add_object', name: name, object: object})
      when 'delete_object'
        name = $(this).children('input[_name="name"]').val().trim()
        object = $(this).children('input[_name="object"]').val().trim()
        configurations.push({type: 'delete_object', name: name, object: object})
      when 'custom_command_value'
        command = $(this).children('input[_name="command"]').val().trim()
        value = $(this).children('input[_name="value"]').val().trim()
        configurations.push({type: 'custom_command_value', command: command, value: value})
      when 'custom_command_age'
        command = $(this).children('input[_name="command"]').val().trim()
        age = $(this).children('input[_name="age"]').val().trim()
        configurations.push({type: 'custom_command_age', command: command, age: age})
      when 'software_version'
        softwareVersion = $(this).children('input[_name="software_version"]').val().trim()
        configurations.push({type: 'software_version', software_version: softwareVersion})
      when 'provision'
        name = $(this).children('input[_name="provision"]').val().trim()
        args = CSV.parse($(this).children('input[_name="args"]').val().trim())[0]
        configurations.push({type: 'provision', name: name, args: args})
  )
  $("##{id} > input[name=configurations]").attr('value', JSON.stringify(configurations))
