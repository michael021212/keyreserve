$(document).ready(function() {

  $('#calendar').fullCalendar({
    schedulerLicenseKey: 'ch_1BgQP1LMwfyPGVhWkF79a6da',
  });

  var ajaxRequest = function ajaxRequest(url, data) {
    return $.ajax({
      url: url,
      type:      "GET",
      dataType:  "json",
      cache:      false,
      data: data
    });
  };

  var facility_ids = $('#facility_calendaers').data('facility')

  $.each(facility_ids, function(i, facility_id) {
    $('#facility_reservation_calendar_' + facility_id).fullCalendar({
      schedulerLicenseKey: '0140948959-fcs-1515040346',
      header: {
        left: 'prev',
        center: 'title',
        right: 'next'
      },
      height: 'auto',
      aspectRatio: 10,
      lang: 'ja',
      eventAfterAllRender: function(){
        $('.fc-week').attr('style', 'min-height: 1.5em');
      }
    });
  });

  $('#facility_reservation_calendar').fullCalendar({
    schedulerLicenseKey: '0140948959-fcs-1515040346',
    header: {
      left: 'prev',
      center: 'title',
      right: 'next'
    },
    height: 'auto',
    aspectRatio: 2,
    lang: 'ja'
  });
});
