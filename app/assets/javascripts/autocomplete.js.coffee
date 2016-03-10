softwareversions = []
productclasses = []
configparamwritablebool = []
configparamwritable = []
objnames = []
objparamwritable = []
svvalue = 'this.InternetGatewayDevice.DeviceInfo.SoftwareVersion._value'
pcvalue = 'this._deviceId._ProductClass'
devicejson = '/devices'
objjson = '/objects'
newconfig = 'div.filter_selection.configurations_selection div.popup a.action'

allpar = (obj) ->
  $.each obj, (key, value) ->
    oobj = undefined
    if $.type(value) == 'object'
      oobj = obj
      obj = value
      allpar obj
      obj = oobj
    if key == '_path'
      if obj._object == true and obj._writable
        objparamwritable.push obj._path
      if obj._type
        if obj._writable
          configparamwritable.push obj._path
        if obj._type == 'xsd:boolean'
          configparamwritablebool.push obj._path

getsv = ->
  softwareversions.length=0
  $.getJSON devicejson, (data) ->
    $.each data, ->
      softwareversions.push eval(svvalue)
      softwareversions = $.unique(softwareversions)
  autocom '#versionselect', softwareversions

window.getpc = ->
  txt = $('#versionselect').val()
  productclasses.length = 0
  $.getJSON devicejson, (data) ->
    $.each data, (sv) ->
      if eval(svvalue) == txt
        productclasses.push eval(pcvalue)
        productclasses = $.unique(productclasses)
  autocom '#productclassselect', productclasses

getobjects = (data) ->
  $.each data, ->
    objnames.push @_id

window.parampush = ->
  versionchoose = $('#versionselect').val()
  productclasschoose = $('#productclassselect').val()
  idarr = []
  $.getJSON devicejson, (data) ->
    $.each data, (i) ->
      if eval(svvalue) == versionchoose and eval(pcvalue) == productclasschoose
        idarr.push data[i]._id
    if idarr.length > 0
      id=idarr[0]
      configparamwritable.length = objparamwritable.length = configparamwritablebool.length = objnames.length = 0
      $.getJSON devicejson + '/' + id, (obj) ->
        ke = obj.InternetGatewayDevice
        allpar ke
        autocom '.accon', configparamwritable
        autocom '.acobjparam', objparamwritable
        autocom '.acobj', objnames
      $.getJSON objjson, getobjects
      $('#notfound').text 'Match found'
    else
      $('#notfound').text 'No match'

window.autocom = (field, source) ->
  $(field).autocomplete(
    source: source
    minLength: 0).focus ->
    $(this).autocomplete 'search'

window.setautocomplete = ->
  getsv()
  $.each $('[configurationType="value"]'),->
    $(this).children(':input').filter(':first').attr 'class': 'accon'
  $.each $('[configurationType="add_object"]'),->
    $(this).children(':input').filter(':first').attr({ 'class' : 'acobj' })
    $(this).children(':input').filter(':last').attr({ 'class' : 'acobjparam' })
  $.each $(newconfig), ->
    clickfunc=($(this).attr 'onclick').split ';'
    $(this).attr 'onclick': clickfunc[0]+';addautocom();return false;'
  $('.accon').focusout ->
    if $.inArray($(this).val(), configparamwritablebool) >= 0
      autocom $(this).next(), [
        'true'
        'false'
      ]
    else
      autocom $(this).next(), []

window.addautocom = ->
  $.each $('[configurationType="value"]'),->
    $(this).children(':input').filter(':first').attr 'class': 'accon'
  $.each $('[configurationType="add_object"]'),->
    $(this).children(':input').filter(':first').attr({ 'class' : 'acobj' })
    $(this).children(':input').filter(':last').attr({ 'class' : 'acobjparam' })
  autocom '.accon', configparamwritable
  autocom '.acobjparam', objparamwritable
  autocom '.acobj', objnames
  $('.accon').focusout ->
    if $.inArray($(this).val(), configparamwritablebool) >= 0
      autocom $(this).next(), [
        'true'
        'false'
      ]
    else
      autocom $(this).next(), []