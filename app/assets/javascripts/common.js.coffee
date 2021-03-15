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

  $(document).ready ->
    calc_price()

  # 料金プランでパックが選ばれているorパックプランしかない場合はパックプランを表示し利用時間を隠す
  $(document).ready ->
    if $('input[name="spot[plan_type]"]:checked, #spot_plan_type').val() == 'pack'
      $('#pack_plan_select').css('display', 'block')
      $('#use_hour_form').hide()
    return

  # 料金プランの選択(ラジオボタン)
  $('input[name="spot[plan_type]"]').change ->
    if $('input[name="spot[plan_type]"]:checked').val() == 'temporary'
      $('#pack_plan_select').css('display', 'none')
      $('#use_hour_form').show()
      spot_use_hour = if !$('#spot_use_hour').val() then spot_use_hour = 'ご利用時間' else spot_use_hour = $('#spot_use_hour').val() + '時間'
      $('#use_hour').find('.cs-placeholder').text(spot_use_hour)
    else
      $('#pack_plan_select').css('display', 'block')
      useHour = $('#facility_pack_plan_id option:selected').data('unit_time')
      $('#spot_use_hour').val(useHour).prop('selected', true)
      $('#use_hour_form').hide()
    return

  # パックプランの選択(セレクトボックス)
  $('#facility_pack_plan_id').change ->
    useHour = $('#facility_pack_plan_id option:selected').data('unit_time')
    $('#spot_use_hour').val(useHour).prop('selected', true)
    calc_price()

  $('#spot_use_num').on 'input', (event) ->
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
