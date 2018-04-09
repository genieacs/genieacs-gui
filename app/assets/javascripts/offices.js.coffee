$(document).on('change', '.select-department', null, (e) ->
  target = $('.select-division')
  return if !target.length

  $.get "/departments/#{$(this).val()}/divisions", (data) ->
    target.empty();
    target.append("<option>Select division</option>")
    $('.select-sector_city').empty();
    $('.select-sector_city').append("<option>Select sector city</option>")
    $('.select-city').empty();
    $('.select-city').append("<option>Select city</option>")
    $('.select-office').empty();
    $('.select-office').append("<option>Select office</option>")

    for i in data
      target.append("<option value='#{i.id}'>#{i.name}</option>")
)

$(document).on('change', '.select-division', null, (e) ->
  target = $('.select-sector_city')
  return if !target.length

  $.get "/divisions/#{$(this).val()}/sector_cities", (data) ->

    target.empty();
    target.append("<option>Select sector city</option>")
    $('.select-city').empty();
    $('.select-city').append("<option>Select city</option>")
    $('.select-office').empty();
    $('.select-office').append("<option>Select office</option>")

    for i in data
      target.append("<option value='#{i.id}'>#{i.name}</option>")
)

$(document).on('change', '.select-sector_city', null, (e) ->
  target = $('.select-city')
  return if !target.length

  $.get "/sector_cities/#{$(this).val()}/cities", (data) ->
    target.empty();
    target.append("<option>Select city</option>")
    $('.select-office').empty();
    $('.select-office').append("<option>Select office</option>")

    for i in data
      target.append("<option value='#{i.id}'>#{i.name}</option>")
)

$(document).on('change', '.select-city', null, (e) ->
  target = $('.select-office')
  return if !target.length

  $.get "/cities/#{$(this).val()}/offices", (data) ->
    target.empty();
    target.append("<option>Select office</option>")
    for i in data
      target.append("<option value='#{i.id}'>#{i.name}</option>")
)

