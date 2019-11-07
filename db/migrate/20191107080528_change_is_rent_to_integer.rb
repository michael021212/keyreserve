class ChangeIsRentToInteger < ActiveRecord::Migration[5.1]
  def up
    rename_column :shops, :is_rent, :shop_type
    change_column :shops, :shop_type, :integer
  end

  def down
    rename_column :shops, :shop_type, :is_rent
    change_column :shops, :is_rent, :boolean
  end
end
