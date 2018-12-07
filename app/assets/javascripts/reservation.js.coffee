$ ->
  $('#confirm_reservaiton_btn').on 'click', ->
    $(this).text('予約中')
    $(this).attr('disabled', 'true')
    $(this).closest('form').submit()
