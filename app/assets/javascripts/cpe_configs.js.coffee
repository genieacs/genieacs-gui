window.toggleSelectedAll = (elem) ->
  $(":checkbox[name='parameter_ids[]']").prop('checked', elem.checked)

window.downloadParameters = () ->
  formElem = $('#download_form')
  formElem.submit() if $(":checkbox[name='ids[]']:checked").length
