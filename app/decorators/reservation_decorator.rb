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

  def block_flag_to_text
    block_flag? ? '◯' : '-'
  end

  def mail_send_flag_to_text
    mail_send_flag? ? '◯' : '-'
  end

  def usage_period_hour
    hour = usage_period.presence || 0
    "#{hour}時間"
  end

  def people_count
    "#{num}名"
  end
  
  def display_user_name
    block_flag? ? I18n.t('common.block') : user_name
  end
end
