class DropinReservationDecorator < Draper::Decorator
  delegate_all

  def price_with_delimiter
    "¥#{ price.to_s(:delimited, delimiter: ',') }"
  end

  def display_payway
    paid_by_credit_card? ? I18n.t('common.credit_card') : I18n.t('common.invoice')
  end

  def mail_send_flag_to_text
    mail_send_flag? ? '◯' : '-'
  end
end
