class InformationDecorator < Draper::Decorator
  delegate_all
  
  def mail_send_flag_to_text
    mail_send_flag? ? '◯' : ''
  end
end
