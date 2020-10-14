class AddDisplayAllFacilitiesDefaultToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :facility_display_range_default, :integer, default: 1, null: false
  end
end
