module ShopHelper

  def selectable_shops
    Shop.all.map{ |s| [s.name, s.corporation_id] }
  end
end
