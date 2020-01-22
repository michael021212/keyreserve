$ ->
  $('.chartered_facility').on 'change', ->
    if $(this).val() == 'true'
      $('.chartered_area').show()
    else
      $('.chartered_area').hide()
