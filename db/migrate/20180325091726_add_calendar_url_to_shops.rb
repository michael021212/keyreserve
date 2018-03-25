class AddCalendarUrlToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :calendar_url, :string
  end
end
