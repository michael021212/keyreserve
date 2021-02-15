class RenameFacilityDisplayRangeColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :facility_display_range, :browsable_range
  end
end
