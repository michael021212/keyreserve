class CreateFacilityTemporaryPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_temporary_plans do |t|
      t.references :facility, null: false
      t.references :plan
      t.integer :standard_price_per_hour, null: false
      t.integer :standard_price_per_day, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
