$ ->
  # データ取得のリクエスト送る用メソッド
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

  # 「詳細」がクリックされたらカレンダー隠す
  $('#detail-tab').on 'click', ->
    $('#user_reservation_calendar').hide()

  # 「予約状況カレンダー」がクリックされたらカレンダー表示
  $('#calendar-tab').on 'click', ->
    $('#user_reservation_calendar').show()

  set_calendar = () ->
    $('#user_reservation_calendar').fullCalendar
      schedulerLicenseKey: '0140948959-fcs-1515040346'
      defaultView: 'agendaWeek'
      header:
        left: 'prev'
        center: 'title'
        right: 'next'
      firstDay: 'today'
      height: 'auto'
      lang: 'ja'
      aspectRatio: 10
      displayEventTime: true
      events: (start, end, timezone, callback) ->
        start = moment(start._d).format('YYYY-MM-DD') # 表示開始日
        end = moment(end._d).format('YYYY-MM-DD')     # 表示終了日
        ajaxRequest(url + '?start=' + start + '&end=' + end).then (events) ->
          callback events
      # カレンダー内の時間をクリックしたときの挙動
      eventClick: (event, jsEvent, view) ->
        date = moment(event.start).format('YYYY/MM/DD')
        time = moment(event.start).format('H:mm')
        $('#spot_checkin').val(date)
        $('#spot_checkin_time').val(time)
        $('html, body').animate { scrollTop: 0 }, 500

  show_calendar = () ->
    $('#calendar-tab').css('pointer-events', '')

  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e)->
    if $(e.target).attr('id') == 'calendar-tab'
      $('#user_reservation_calendar').fullCalendar('rerenderEvents')

  set_calendar()
  show_calendar()


