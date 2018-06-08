class CreateFacilityDropinPeriodPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_dropin_sub_plans do |t|
      t.references :facility_dropin_plan, index: true, null: false
      t.string :name, null:false
      t.time :starting_time, null: false
      t.time :ending_time, null: false
      t.integer :price, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
