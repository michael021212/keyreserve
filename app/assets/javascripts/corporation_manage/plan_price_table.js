var ajaxRequest = function ajaxRequest(url) {
  return $.ajax({
    url: url,
    type: "GET",
    dataType: "json",
    cache: false
  });
};

$(document).ready(function() {
  var shop_id = gon.shop_id
  var facility_id = gon.facility_id

  $('#js-plan-price-table').fullCalendar({
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
        `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/facility_temporary_plans/resources`
      ).then(function(resources) {
        callback(resources);
      })
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          ajaxRequest(
            `/corporation_manage/shops/${shop_id}/facilities/${facility_id}/facility_temporary_plans/events`
          ).then(function(events) {
            callback(events);
          })
        }
      }
    ]
  });
});
