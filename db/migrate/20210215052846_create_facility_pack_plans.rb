class CreateFacilityPackPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_pack_plans do |t|
      t.references :facility, null: false
      t.references :plan
      t.integer :ks_room_key_id, null: false
      t.string :guide_mail_title
      t.text :guide_mail_content
      t.string :guide_file
      t.integer :unit_time, null: false
      t.integer :unit_price, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
