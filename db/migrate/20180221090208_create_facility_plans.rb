class CreateFacilityPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_plans do |t|
      t.references :facility, null: false
      t.references :plan, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
