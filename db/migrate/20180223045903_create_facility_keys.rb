class CreateFacilityKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_keys do |t|
      t.references :facility, null: false
      t.integer :key_id, null: false
      t.integer :ks_room_key_id, null: false
      t.string :name, null: false
      t.string :password
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
