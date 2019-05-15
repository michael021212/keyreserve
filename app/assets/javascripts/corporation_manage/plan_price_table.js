var ajaxRequest = function (url) {
  return $.ajax({
    url: url,
    type: "GET",
    dataType: "json",
    cache: false
  });
};

var planPriceTableScheduller = function (target_class, target_plan_name, target_events_name) {
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
        `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/${target_plan_name}`
      ).then(function(resources) {
        callback(resources);
      })
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          ajaxRequest(
            `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/${target_events_name}`
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

$(document).ready(function() {
  planPriceTableScheduller('#js-temporary-plan-table', 'facility_temporary_plans', 'temporary_events')
  planPriceTableScheduller('#js-dropin-plan-table', 'facility_dropin_plans', 'facility_dropin_sub_plans')
});
