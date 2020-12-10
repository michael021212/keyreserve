class FacilityDecorator < Draper::Decorator
  delegate_all

  def display_name
    rent? ? "#{name} - #{Shop.find_by(id: Facility::RENT_SHOP_ID).name}" : "#{name}"
  end
end
