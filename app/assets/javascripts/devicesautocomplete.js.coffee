window.getsupported = (path) ->
  op = 'Operating'
  txt = path.split('.')
  if txt[txt.length - 1].indexOf(op) >= 0
    sup = path.replace(op, 'Supported')
    arr = $('li:contains(' + sup + ')').children('.param-value').text().split(',')
    $('div.modal-wrapper div.modal input').attr 'class': 'acop'
    autocom '.acop', arr

window.searchparam = ->
  $.extend $.expr[':'], 'containsIN': (elem, i, match, array) ->
    (elem.textContent or elem.innerText or '').toLowerCase().indexOf((match[3] or '').toLowerCase()) >= 0
  $(this).keyup ->
    txt = $('.search').val()
    if txt == ''
      $('.param-path').parent().show()
    else
      $('.param-path').parent().hide()
      $('.param-path:containsIN("' + txt + '")').parent().show()

window.setdeviceautocomplete=->
  $('.search').attr 'onfocus': 'searchparam();'
  $.each $('.param-path:contains("Operating")'), ->
    clickfunc=$(this)
      .parent()
      .children '.actions'
      .children 'a'
      .filter ':first'
      .attr 'onclick'
      .split ';'
    $(this)
      .parent()
      .children '.actions'
      .children 'a'
      .filter ':first'
      .attr 'onclick': clickfunc[0]+';getsupported("'+$(this).text()+'");return false;'