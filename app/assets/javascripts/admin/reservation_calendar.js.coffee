$ ->
  $('#calendar').fullCalendar schedulerLicenseKey: 'ch_1BgQP1LMwfyPGVhWkF79a6da'
  closing = $('#reservation_calendar').data('closing')
  opening = $('#reservation_calendar').data('opening')
  corporation_id = $('#reservation_calendar').data('corporation')
  facility_id = $('#reservation_calendar').data('facility')
  url = '/admin/corporations/' + corporation_id + '/facilities/' + facility_id + '/events'

  $('#reservation_calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaWeek'
    header:
      left: 'prev,next'
      center: 'title'
      right: 'agendaDay,agendaWeek,month'
    slotDuration: '01:00:00'
    height: 'auto'
    lang: 'ja'
    businessHours: [
      {
        dow: [0, 1, 2, 3, 4, 5, 6]
        start: opening
        end: closing
      }
    ]
    displayEventEnd: {
      month: true
    }
    events: url
