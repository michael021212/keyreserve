class FacilityDecorator < Draper::Decorator
  delegate_all

  def display_min_price(user)
    if choosable_temporary_plans(user).present?
      "#{min_hourly_price(user)}円 / h ~"
    else
      "#{unit_times(user).first}時間#{((min_prices_for_each_unit_time(user).first) * Payment::TAX_RATE).floor}円〜"
    end
  end
end
