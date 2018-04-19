$ ->
  plan_id = $('.mg-plan-read-more').data('plan')

  $('#plan-read-more-' + plan_id).mouseenter ->
    $('.popover-plan-description').popover(html: true).popover 'show'

  $('#plan-read-more-' + plan_id).mouseleave ->
    $('.popover-plan-description').popover('hide')
