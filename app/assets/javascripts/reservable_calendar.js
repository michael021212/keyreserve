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

  var facility_ids = $('#facility_calendars').data('facility')
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
      displayEventTime: false,
      events: function (start, end, timezone, callback) {
        facility_id = this.el[0].id.replace('facility_reservation_calendar_', '')
        ajaxRequest(
          '/facilities/' + facility_id + '/reservations/events'
        ).then(function(events) {
          callback(events);
        })
      },
      eventRender: function(event, element){
        element.popover({
          placement: 'left',
          animation:true,
          content: event.start,
          trigger: 'hover'
        });
      },
    });
  });
});
