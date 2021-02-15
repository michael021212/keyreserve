class RemoveShopTypeFromShops < ActiveRecord::Migration[5.1]
  def change
    remove_column :shops, :shop_type, :integer
  end
end
