module ShopHelper

  def selectable_shops
    Shop.where.not(is_rent: true).map{ |s| [s.name, s.corporation_id] }
  end
end
