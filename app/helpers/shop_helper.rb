module ShopHelper

  def selectable_shops
    Shop.where(registerable: true).map{ |s| [s.name, s.corporation_id] }
  end
end
