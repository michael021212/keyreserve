$ ->
  $('#facility_facility_type').on 'change', ->
    if $(this).val() == 'chartered_place'
      $('.chartered_area').show()
    else
      $('.chartered_area').hide()

  $('.chartered_radio').on 'change', ->
    if $(this).val() == 'true'
      $('.chartered_area').show()
    else
      $('.chartered_area').hide()

