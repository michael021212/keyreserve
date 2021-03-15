dropin_price = ->
  fid = $('#js-dropin-price').data('fid')
  sub_plan = $('#js-dropin-price').data('sub-plan')
  return unless fid
  url = "/dropin_reservations/plan"
  $.ajax({
    url: url,
    type:      "GET"
    dataType:  "json"
    cache:      false
    data: $('.js-dropin-price-form').serialize() + '&facility_id=' + fid
  }).done((data) ->
    $('#js-dropin-price').text(data.price)
    $('#js-dropin-time').text(data.time)
  )

dropin_price()
$('#dropin_spot_sub_plan').change () ->
  dropin_price()

$('#dropin_timepicker').wickedpicker({
  now: if $('#dropin_timepicker').val() then $('#dropin_timepicker').val() else '11:00'
  upArrow: 'fas fa-angle-up'
  downArrow: 'fas fa-angle-down'
  twentyFour: true
  title: 'ご利用時刻'
  minutesInterval: 30
})
