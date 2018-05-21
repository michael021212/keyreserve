$ ->

  ajaxRequest = (url, data) ->
    $.ajax
      url: url
      type: 'GET'
      dataType: 'json'
      cache: false
      data: data

  facility_id = $('#user_reservation_calendar').data('facility')
  shop_id = $('#user_reservation_calendar').data('shop')
  # url = '/shops/' + shop_id + '/facilities/' + facility_id + '/events'
  # start = $('#user_reservation_calendar').fullCalendar('getView').start.format('M/DD')
  # end = $('#user_reservation_calendar').fullCalendar('getView').end.format('M/DD')
  url = '/shops/' + shop_id + '/facilities/' + facility_id + '/events'

  $('#user_reservation_calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaWeek'
    header:
      left: 'prev,next'
      center: 'title'
      right: 'agendaWeek,month'
    slotDuration: '01:00:00'
    height: 'auto'
    lang: 'ja'
    aspectRatio: 10
    businessHours: [
      {
        dow: [0, 1, 2, 3, 4, 5, 6]
        start: '09:00'
        end: '21:00'
      }
    ]
    # events: url
    # eventSources: [ { events: (start, end, timezone, callback) -> } ]
    events: (start, end, timezone, callback) ->
      start = moment(start._d).format('YYYY-MM-DD')
      end = moment(end._d).format('YYYY-MM-DD')
      ajaxRequest(url + '?start=' + start + '&end=' + end).then (events) ->
        callback events
