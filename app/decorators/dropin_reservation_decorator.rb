class DropinReservationDecorator < Draper::Decorator
  delegate_all

  def price_with_delimiter
    "¥#{ price.to_s(:delimited, delimiter: ',') }"
  end

end
