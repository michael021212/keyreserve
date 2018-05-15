$ ->
  $('#calendar').fullCalendar schedulerLicenseKey: 'ch_1BgQP1LMwfyPGVhWkF79a6da'

  ajaxRequest = (url) ->
    $.ajax
      url: url
      type: 'GET'
      dataType: 'json'
      cache: false
      data: ''

  closing = $('#reservation_calendar').data('closing')
  opening = $('#reservation_calendar').data('opening')
  corporation_id = $('#reservation_calendar').data('corporation')
  facility_id = $('#reservation_calendar').data('facility')
  url = '/admin/corporations/' + corporation_id + '/facilities/' + facility_id + '/events'

  $('#reservation_calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaWeek'
    header:
      left: 'prev'
      center: 'title'
      right: 'next'
    height: 'auto'
    lang: 'ja'
    displayEventTime: false
    businessHours: [
      {
        dow: [0, 1, 2, 3, 4, 5, 6]
        start: opening
        end: closing
      }
    ]
    eventSources: [
      {
        events: (start, end, timezone, callback) ->
          ajaxRequest(url) ->
            callback events
      }
    ]
