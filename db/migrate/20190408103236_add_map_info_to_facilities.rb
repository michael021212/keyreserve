class AddMapInfoToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :address, :string
    add_column :facilities, :lat, :float
    add_column :facilities, :lon, :float
  end
end
