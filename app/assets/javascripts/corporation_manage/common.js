$(document).on('ready', function () {
  var $this = $('#reservation_block_flag')
  if ($this.is(':checked')) {
    $('#reservation_user_id').val('')
    $('#reservation_user_id').attr('disabled', 'true')
  } else {
    $('#reservation_user_id').removeAttr('disabled')
  }
})

$(document).on('click', '#reservation_block_flag', function () {
  var $this = $(this)
  if ($this.is(':checked')) {
    $('#reservation_user_id').val('')
    $('#reservation_user_id').attr('disabled', 'true')
  } else {
    $('#reservation_user_id').removeAttr('disabled')
  }
})
