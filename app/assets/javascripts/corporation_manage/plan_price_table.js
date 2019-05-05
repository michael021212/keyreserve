var ajaxRequest = function ajaxRequest(url) {
  return $.ajax({
    url: url,
    type: "GET",
    dataType: "json",
    cache: false
  });
};

var planPriceTableScheduller = function planPriceTableScheduller(target_class, target_plan_name) {
  var shop_id = $(target_class).data('shop-id')
  var facility_id = $(target_class).data('facility-id')

  $(target_class).fullCalendar({
    schedulerLicenseKey: gon.schedular_licence_key,
    defaultView: 'agendaDay',
    header: false,
    height: 'auto',
    lang: 'ja',
    slotDuration: '00:30:00',
    slotLabelInterval: '00:30:00',
    resources: function (callback) {
      ajaxRequest(
        '/corporation_manage/shops/' + shop_id + '/facilities/' + facility_id + '/' + target_plan_name + '/resources'
      ).then(function(resources) {
        callback(resources);
      })
    },
    resourceRender: function(resource, el) {
      link = '/corporation_manage/shops/' + shop_id + '/facilities/' + facility_id + '/' + target_plan_name + '/' + resource.id + '/edit';
      el.append("<p><a href=" + link + '>編集</a></p>');
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          ajaxRequest(
            '/corporation_manage/shops/' + shop_id + '/facilities/' + facility_id + '/' + target_plan_name + '/events'
          ).then(function(events) {
            callback(events);
          })
        }
      }
    ]
  })

  if (target_class == '#js-dropin-plan-table') {
    $(target_class).fullCalendar('option', 'allDaySlot', false)
  }
};

var setReservationCalender = function setReservationCalender(target_class) {
  var opening_time = $(target_class).data('opening-time');
  var closing_time = $(target_class).data('closing-time');
  var shop_id = $(target_class).data('shop-id');
  var facility_id = $(target_class).data('facility-id');

  $(target_class).fullCalendar({
    schedulerLicenseKey: gon.schedular_licence_key,
    defaultView: 'agendaDay',
    header: {
      left: 'prev,next',
      center: 'title',
      right: 'today agendaDay,agendaWeek,month'
    },
    height: 'auto',
    lang: 'ja',
    slotDuration: '00:30:00',
    slotLabelInterval: '00:30:00',
    businessHours: [
      {
        dow: [0, 1, 2, 3, 4, 5, 6],
        start: opening_time,
        end: closing_time
      }
    ],
    displayEventEnd: {
      month: true
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          ajaxRequest(
            '/corporation_manage/shops/' + shop_id + '/facilities/' + facility_id + '/events'
          ).then(function(events) {
            callback(events);
          })
        }
      }
    ]
  })
};

$(document).ready(function() {
  planPriceTableScheduller('#js-temporary-plan-table', 'facility_temporary_plans')
  planPriceTableScheduller('#js-dropin-plan-table', 'facility_dropin_plans')
  setReservationCalender('#js-reservation-calendar')
});
