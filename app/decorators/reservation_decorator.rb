class ReservationDecorator < Draper::Decorator
  delegate_all

  def price_with_delimiter
    "¥#{ price.to_s(:delimited, delimiter: ',') }"
  end

  def usage_period_with_unit
    "#{ usage_period }時間"
  end

end

