class CreateDropinKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :dropin_keys do |t|
      t.references :facility_dropin_plan, index: true, null: false
      t.integer :ks_room_key_id, null:false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
