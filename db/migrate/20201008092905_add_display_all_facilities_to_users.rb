class AddDisplayAllFacilitiesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :facility_display_range, :integer, default: 1, null: false
  end
end
