$(document).on('click', '.close', null, (e) ->
  $(this).parent().remove();
)

window.addRole = () ->
  roleIds = $('input[name="role_ids"]').val().split(',')
  if roleIds.indexOf($('#user_roles').val()) == -1
    $('#roles-added').append '' +
      '<div class="badge badge-pill badge-dark">' +
        $('#user_roles option:selected').text() +
        '<input type="hidden" name="user[role_ids][]" value="' + $('#user_roles').val() + '">' +
        '<span class="close">&nbsp; X &nbsp;</span>' +
      '</div>'

    roleIds.push $('#user_roles').val()
    $('input[name="role_ids"]').val roleIds.join(',')
    $('#roles-added').append()
  $('#user_roles').val null

document.addEventListener "turbolinks:load", () ->
  $('#user_sector_city_id').select2()
  $('#user_city_id').select2()
  $('#user_office_id').select2()