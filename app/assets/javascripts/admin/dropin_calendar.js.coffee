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
  $('#dropin-calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaDay'
    header: false
    height: 'auto'
    lang: 'ja'
    slotDuration: '00:30:00'
    slotLabelInterval: '00:30:00'
    slotEventOverlap: false
    allDayText: '時間\n単位'
    resourceRender: (resource, el) ->
      link = '/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/' + resource.id + '/edit'
      el.append '<p><a href=' + link + '>編集</a></p>'

    resources: (callback) ->
      ajaxRequest('/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/resources').then (resources) ->
        callback resources
    eventSources: [ { events: (start, end, timezone, callback) ->
      ajaxRequest('/admin/corporations/' + corporation + '/facilities/' + facility + '/facility_dropin_plans/events').then (events) ->
        callback events
    } ]
