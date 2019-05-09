$ ->
  disp_info_shops = ->
    if $('#information_info_target_type').val() == 'all_users'
      $('.js-info-shops').hide()
    else
      $('.js-info-shops').show()

  $('#information_info_target_type').on 'change', disp_info_shops
