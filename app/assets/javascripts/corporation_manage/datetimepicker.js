var addDateTimePicker = function addDateTimePicker(target_class) {
  $(target_class).datetimepicker({
    stepping: 30
  });
};

$(document)
  .on('ready', function () {
    addDateTimePicker('.js-dropin-starting-time');
    addDateTimePicker('.js-dropin-ending-time');
  })

  .on('nested:fieldAdded', function() {
    addDateTimePicker('.js-dropin-starting-time');
    addDateTimePicker('.js-dropin-ending-time');
  });
