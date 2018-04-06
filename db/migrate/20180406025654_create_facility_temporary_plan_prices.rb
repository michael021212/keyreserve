class CreateFacilityTemporaryPlanPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_temporary_plan_prices do |t|
      t.references :facility_temporary_plan, null: false, index: { name: 'index_prices_on_facility_temporary_plan_id' }
      t.time :starting_time, null: false
      t.time :ending_time, null: false
      t.integer :price, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
