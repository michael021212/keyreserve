

  $('.calendar_toggle').on('click', function() {
    var ajaxRequest, facility_id, set_calendar, shop_id, url;
    ajaxRequest = function(url, data) {
      return $.ajax({
        url: url,
        type: 'GET',
        dataType: 'json',
        cache: false,
        data: data
      });
    };
    var id = $(this).parents('.calendar_toggle_parent').next('div').find('.user_reservation_calendar').attr('id')
    facility_id = $(`#${id}`).data('facility');
    shop_id = $(`#${id}`).data('shop');
    url = '/shops/' + shop_id + '/facilities/' + facility_id + '/events';
    set_calendar = function() {
      return $(`#${id}`).fullCalendar({
        schedulerLicenseKey: '0140948959-fcs-1515040346',
        defaultView: 'agendaWeek',
        header: {
          left: 'prev',
          center: 'title',
          right: 'next'
        },
        firstDay: 'today',
        height: 'auto',
        lang: 'ja',
        aspectRatio: 10,
        displayEventTime: true,
        events: function(start, end, timezone, callback) {
          start = moment(start._d).format('YYYY-MM-DD');
          end = moment(end._d).format('YYYY-MM-DD');
          return ajaxRequest(url + '?start=' + start + '&end=' + end).then(function(events) {
            return callback(events);
          });
        }
      });
    };
    $(`#${id}`).parent('div').slideToggle();
    $(this).toggleClass('active');
    set_calendar();
  });
