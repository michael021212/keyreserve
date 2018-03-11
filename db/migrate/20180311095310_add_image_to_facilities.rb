class AddImageToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :image, :string
    add_column :facilities, :description, :text
  end
end
