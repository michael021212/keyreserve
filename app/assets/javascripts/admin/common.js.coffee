$ ->
  disp_info_shops = ->
    if $('#information_info_target_type').val() == 'all_users'
      $('.js-info-shops').hide()
    else
      $('.js-info-shops').show()

  $('#information_info_target_type').on 'change', disp_info_shops

  disp_info_shops()

  # 予約新規登録
 if $('#reservation_block_flag').is(':checked')
    $('#reservation_user_id').val('')
    $('#reservation_user_id').attr('disabled', 'true')
 $("label[for='reservation_block_flag']").on 'click', ->
    if $('#reservation_block_flag').is(':checked')
      $('#reservation_user_id').val('')
      $('#reservation_user_id').attr('disabled', 'true')
    else
      $('#reservation_user_id').removeAttr('disabled')

  # 施設利用都度課金
  $('#insert-pwd').on 'click', (event) ->
    event.preventDefault()
    currentPosition = $('#guide-mail-content')[0].selectionStart
    textAreaTxt = $('#guide-mail-content').val()
    $('#guide-mail-content').val(textAreaTxt.substring(0, currentPosition) + '[[password]]' + textAreaTxt.substring(currentPosition))

  new ScrollHint('.js-scrollable',
    enableOverflowScrolling: true
    suggestiveShadow: true
    i18n: scrollable: 'スクロールできます')
