class AddInfoTargetTypeToInformation < ActiveRecord::Migration[5.1]
  def change
    add_column :information, :info_target_type, :integer, null: false, default: 2
  end
end
