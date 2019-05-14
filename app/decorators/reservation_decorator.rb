class ReservationDecorator < Draper::Decorator
  delegate_all

  def price_with_delimiter
    "¥#{ price.to_s(:delimited, delimiter: ',') }"
  end

  def usage_period_with_unit
    "#{ usage_period }時間"
  end

  def display_payway
    paid_by_credit_card? ? I18n.t('common.credit_card') : I18n.t('common.invoice')
  end

  def display_user_name
    block_flag? ? 'ブロック' : user_name
  end
end
