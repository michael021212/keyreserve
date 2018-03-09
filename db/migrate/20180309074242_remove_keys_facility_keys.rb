class RemoveKeysFacilityKeys < ActiveRecord::Migration[5.1]
  def change
    remove_column :facility_keys, :key_id
    remove_column :facility_keys, :password
  end
end
