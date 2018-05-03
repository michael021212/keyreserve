class AddNumToMisc < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :max_num, :integer, default: 0
    add_column :facilities, :facility_type, :integer, default: 0
    add_column :reservations, :num, :integer, default: 0
  end
end
