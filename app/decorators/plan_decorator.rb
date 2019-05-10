class PlanDecorator < Draper::Decorator
  delegate_all

  def default_flag_to_string
    if default_flag?
      '◯'
    else
      '-'
    end
  end
end
