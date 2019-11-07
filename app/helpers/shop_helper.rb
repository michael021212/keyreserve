module ShopHelper

  def selectable_shops
    Shop.general.map{ |s| [s.name, s.corporation_id] }
  end
end
