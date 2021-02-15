class AddDisclosureRangeToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :disclosure_range, :integer, null: false, default: 0
  end
end
