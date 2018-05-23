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
  url = '/shops/' + shop_id + '/facilities/' + facility_id + '/events'

  $('#detail-tab').on 'click', ->
    $('#user_reservation_calendar').hide()

  $('#calendar-tab').on 'click', ->
    $('#user_reservation_calendar').show()

  $('#user_reservation_calendar').fullCalendar
    schedulerLicenseKey: '0140948959-fcs-1515040346'
    defaultView: 'agendaWeek'
    header:
      left: 'prev'
      center: 'title'
      right: 'next'
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
    events: (start, end, timezone, callback) ->
      start = moment(start._d).format('YYYY-MM-DD')
      end = moment(end._d).format('YYYY-MM-DD')
      ajaxRequest(url + '?start=' + start + '&end=' + end).then (events) ->
        callback events
     eventClick: (event, jsEvent, view) ->
       date = moment(event.start).format('YYYY/MM/DD')
       time = moment(event.start).format('H:mm')
       $('#spot_checkin').val(date)
       $('#spot_checkin_time').val(time)
       alert("ご利用日: " + date + "\n" + "ご利用時刻: " + time + "\n" + "上記の内容を上方のご予約フォームに入力しました")

  $('#calendar-tab').on 'click', ->
    $('#user_reservation_calendar').fullCalendar('refetchEvents')
