class AddImageToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :image, :string, default: nil, after: :closing_time
  end
end
