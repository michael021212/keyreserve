class AddNullFalseToFacilityType < ActiveRecord::Migration[5.1]
  def up
    change_column :facilities, :facility_type, :integer, default: nil, null: false
  end

  def down
    change_column :facilities, :facility_type, :integer, default: 0, null: true
  end
end
