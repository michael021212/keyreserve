var dispInfoShops = function () {
  if($('#information_info_target_type').val() == 'all_users') {
    $('.js-info-shops').hide()
  } else {
    $('.js-info-shops').show()
  }
};

var disabledForm = function (target_class) {
  $(target_class).val('')
  $(target_class).attr('disabled', 'true')
};

var enabledForm = function (target_class) {
  $(target_class).removeAttr('disabled', 'false')
};

var hideForm = function (target_class) {
  $(target_class).hide()
};

var showForm = function (target_class) {
  $(target_class).show()
}

var disabledReservationForms = function (target_class) {
  if ($(target_class).is(':checked')) {
    disabledForm('#reservation_user_id');
    disabledForm('#reservation_num');
    hideForm('.js-mail-send-flag')
  } else {
    enabledForm('#reservation_user_id');
    enabledForm('#reservation_num');
    showForm('.js-mail-send-flag')
  }
};

var checkAll = function(selectorCheckAll, selectorCheckBox) {
  if ($(selectorCheckAll).prop('checked')) {
    $(selectorCheckBox).prop('checked', true);
  } else {
    $(selectorCheckBox).prop('checked', false);
  }
};

$(document)
  .on('ready', function () {
    dispInfoShops();
    disabledReservationForms('#reservation_block_flag')
  })

  .on('click', '#reservation_block_flag', function (e) {
    disabledReservationForms(e.target)
  })

  .on('change', '#information_info_target_type', function () {
    dispInfoShops();
  })

  .on('click', '.js-all-checkbox', function (e) {
    checkAll(e.target, '.js-shop-checkbox')
  });
