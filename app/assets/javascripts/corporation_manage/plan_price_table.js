var ajaxRequest = function (url) {
  return $.ajax({
    url: url,
    type: "GET",
    dataType: "json",
    cache: false
  });
};

var planPriceTableScheduller = function (target_class, target_plan_name, target_resources_action, target_events_action) {
  var shop_id = gon.shop_id
  var facility_id = gon.facility_id

  $(target_class).fullCalendar({
    schedulerLicenseKey: gon.schedular_licence_key,
    defaultView: 'agendaDay',
    header: false,
    height: 'auto',
    lang: 'ja',
    slotDuration: '00:30:00',
    slotLabelInterval: '00:30:00',
    resourceRender: function(resource, el) {
      link = `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/facility_temporary_plans/${resource.id}/edit`;
      el.append("<p><a href=" + link + '>編集</a></p>');
    },
    resources: function (callback) {
      ajaxRequest(
        `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/${target_plan_name}/${target_resources_action}`
      ).then(function(resources) {
        callback(resources);
      })
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          ajaxRequest(
            `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/${target_plan_name}/${target_events_action}`
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
  var opening_time = gon.opening_time;
  var closing_time = gon.closing_time;
  var shop_id = gon.shop_id;
  var facility_id = gon.facility_id;

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
            `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/facility_events`
          ).then(function(events) {
            callback(events);
          })
        }
      }
    ]
  })
};

$(document).ready(function() {
  planPriceTableScheduller('#js-temporary-plan-table', 'facility_temporary_plans', 'temporary_plan_infos', 'temporary_events')
  planPriceTableScheduller('#js-dropin-plan-table', 'facility_dropin_plans', 'dropin_plan_infos', 'dropin_events')
  setReservationCalender('#js-reservation-calendar')
});
