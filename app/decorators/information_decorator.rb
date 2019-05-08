class InformationDecorator < Draper::Decorator
  delegate_all
  
  def mail_send_flag_to_string
    if mail_send_flag?
      '◯'
    else
      ''
    end
  end
end
