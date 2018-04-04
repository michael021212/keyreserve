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

  $('#plan_price_table').fullCalendar({
    schedulerLicenseKey: '0140948959-fcs-1515040346',
    defaultView: 'agendaDay',
    header: false,
    lang: 'ja',
    viewRender: function(view, element) {
      element.find('.fc-day-header').html('');
    },
    resourceColumns: [{
      labelText: 'プラン名',
      text: function(resource) {
        var title = resource.title;
        return title;
      }
    }],
    resources: function (callback) {
      var corporation = $('#plan_price_table').data('corporation')
      var shop = $('#plan_price_table').data('shop')
      var facility = $('#plan_price_table').data('facility')
      ajaxRequest(
        "/admin/corporations/" + corporation + "/shops/" + shop + "/facilities/" + facility + "/resources"
      ).then(function(resources) {
        callback(resources);
      })
    }
  });
});
