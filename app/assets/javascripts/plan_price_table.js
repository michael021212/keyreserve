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

  var corporation = $('#plan_price_table').data('corporation')
  var shop = $('#plan_price_table').data('shop')
  var facility = $('#plan_price_table').data('facility')

  $('#plan_price_table').fullCalendar({
    schedulerLicenseKey: '0140948959-fcs-1515040346',
    defaultView: 'agendaDay',
    header: false,
    height: 'auto',
    lang: 'ja',
    slotDuration: '01:00:00',
    resourceRender: function(resource, el) {
      if (corporation === undefined && shop === undefined) {
        link = "/facilities/" + facility + "/facility_temporary_plans/" + resource.id + "/edit"
      } else {
        link = "/admin/corporations/" + corporation + "/facilities/" + facility + "/facility_temporary_plans/" + resource.id + "/edit"
      }
      el.append("<p><a href=" + link + '>編集</a></p>');
    },
    resources: function (callback) {
      if (corporation === undefined && shop === undefined) {
        ajaxRequest(
          "/facilities/" + facility + "/facility_temporary_plans/resources"
        ).then(function(resources) {
          callback(resources);
        })
      } else {
        ajaxRequest(
          "/admin/corporations/" + corporation + "/facilities/" + facility + "/facility_temporary_plans/resources"
        ).then(function(resources) {
          callback(resources);
        })
      }
    },
    eventSources: [
      {
        events: function (start, end, timezone, callback) {
          if (corporation === undefined && shop === undefined) {
            ajaxRequest(
              '/facilities/' + facility + '/facility_temporary_plans/events'
            ).then(function(events) {
              callback(events);
            })
          } else {
            ajaxRequest(
              '/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_temporary_plans/events'
            ).then(function(events) {
              callback(events);
            })
          }
        }
      }
    ]
  });
});
