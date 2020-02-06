class AddRegisterableToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :registerable, :boolean, default: false
  end
end
