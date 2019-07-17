class AddPublishedToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :published, :boolean, default: true
  end
end
