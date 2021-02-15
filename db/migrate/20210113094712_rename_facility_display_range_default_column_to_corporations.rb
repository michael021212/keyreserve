class RenameFacilityDisplayRangeDefaultColumnToCorporations < ActiveRecord::Migration[5.1]
  def change
    rename_column :corporations, :facility_display_range_default, :browsable_range_default
  end
end
