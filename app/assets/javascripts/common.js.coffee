$ ->
  calc_price = ->
    fid = $('#js-price').data('fid')
    return unless fid
    url = "/reservations/price"
    $.ajax({
      url: url,
      type:      "GET"
      dataType:  "json"
      cache:      false
      data: $('.js-calc-price-form').serialize() + '&facility_id=' + fid
    }).done((data) ->
      $('#js-price').text(data.price)
    )
  calc_price()

  [].slice.call(document.querySelectorAll('select.cs-select')).forEach (el) ->
    if $(el).hasClass('js-calc-price')
      new SelectFx(el, {
        onChange: (val) ->
          calc_price()
      })
    else
      new SelectFx(el)
    return

  $('.timepicker').wickedpicker({
    now: if $('#spot_checkin_time').val() then $('#spot_checkin_time').val() else '12:00'
    upArrow: 'fas fa-angle-up'
    downArrow: 'fas fa-angle-down'
    twentyFour: true
    title: 'ご利用時刻'
    minutesInterval: 30
    afterShow: ->
      if $(el).hasClass('js-calc-price')
        calc_price()
  })

  $('.js-calc-price').on 'change', ->
    calc_price()

  $ ->
    windowWidth = $(window).width()
    headerHight = 80
    $('.lower_by_header').click ->
      speed = 200
      href = $(this).attr('href')
      target = '#' + href.split('#')[1]
      position = $(target).offset().top - headerHight
      $('body,html').animate { scrollTop: position }, speed, 'swing'
      false
    return

  new ScrollHint('.js-scrollable',
    enableOverflowScrolling: true
    suggestiveShadow: true
    i18n: scrollable: 'スクロールできます')
