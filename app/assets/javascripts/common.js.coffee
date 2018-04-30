$ ->
  calc_price = -> 
    fid = $('#js-price').data('fid')
    url = "/facilities/#{fid}/get_price"
    $.ajax({
      url: url,
      type:      "GET"
      dataType:  "json"
      cache:      false
      data: $('.js-calc-price-form').serialize()
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
    now: $('#spot_checkin_time').val()
    upArrow: 'arrow-font angle-up'
    downArrow: 'arrow-font angle-down'
    twentyFour: true
    title: 'ご利用時刻'
    minutesInterval: 60
    afterShow: ->
      if $(el).hasClass('js-calc-price')
        calc_price()
  })

  $('.js-calc-price').on 'change', ->
    calc_price()


