class InformationDecorator < Draper::Decorator
  delegate_all
  
  def mail_send_flag_circle_string
    if mail_send_flag?
      '◯'
    else
      ''
    end
  end
end
