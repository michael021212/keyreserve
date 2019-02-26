class BillingDecorator < Draper::Decorator
  delegate_all

  def month_with_year
    "#{ year }年#{ month }月"
  end

  def price_with_delimiter
    "¥#{ price.to_s(:delimited, delimiter: ',') }"
  end

end
