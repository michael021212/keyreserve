$ ->
  $('#user_user_type_parent_corporation').change (e) ->
    $('#new_or_exist_parent').css('display', 'block')

  $('#user_user_type_personal').change (e) ->
    $('#new_or_exist_parent').css('display', 'none')

  $('#new_parent_user_type').change (e) ->
    $('#new_parent_field').css('display', 'block')
    $('#exist_parent_field').css('display', 'none')
    $('#exist_parent_user_type').removeAttr("checked")

  $('#exist_parent_user_type').change (e) ->
    $('#new_parent_field').css('display', 'none')
    $('#exist_parent_field').css('display', 'block')
    $('#new_parent_user_type').removeAttr("checked")

  if ($('#user_user_type_parent_corporation').is(':checked') )
    $('#new_or_exist_parent').css('display', 'block')
    if ($('#new_parent_user_type').is(':checked') )
      $('#new_parent_field').css('display', 'block')
    else
      $('#exist_parent_field').css('display', 'block')
