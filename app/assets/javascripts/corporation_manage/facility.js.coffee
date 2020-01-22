$ ->
  $('#facility_facility_type').on 'change', ->
    if $(this).val() == 'chartered_place'
      $('.chartered_area').show()
    else
      $('.chartered_area').hide()
