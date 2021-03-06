$(document).ready ->
  $('#calendar').fullCalendar schedulerLicenseKey: 'ch_1BgQP1LMwfyPGVhWkF79a6da'

  ajaxRequest = (url, data) ->
    $.ajax
      url: url
      type: 'GET'
      dataType: 'json'
      cache: false
      data: data

  corporation = $('#dropin-calendar').data('corporation')
  facility = $('#dropin-calendar').data('facility')
  opening = $('#dropin-calendar').data('opening')
  closing = $('#dropin-calendar').data('closing')

  $('#dropin-calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaDay'
    header: false
    height: 'auto'
    lang: 'ja'
    slotDuration: '00:30:00'
    slotLabelInterval: '00:30:00'
    slotEventOverlap: false
    allDaySlot: false
    businessHours: [
      {
        dow: [0, 1, 2, 3, 4, 5, 6]
        start: opening
        end: closing
      }
    ]
    resourceRender: (resource, el) ->
      link = '/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/' + resource.id + '/edit'
      el.append '<p><a href=' + link + '>編集</a></p>'
    resources: '/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/resources'
    events: '/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/events'
