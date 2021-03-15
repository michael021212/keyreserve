module ShopHelper

  def selectable_shops
    Shop.where(registerable: true).map{ |s| [s.name, s.corporation_id] }
  end

  def need_liferee_link?
    hundled_on_liferee_shops_ids = [32, 33]
    @shop.id.in?(hundled_on_liferee_shops_ids)
  end
end
