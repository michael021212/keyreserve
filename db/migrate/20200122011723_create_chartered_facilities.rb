class CreateCharteredFacilities < ActiveRecord::Migration[5.1]
  def change
    create_table :chartered_facilities do |t|
      t.references :facility, index: true
      t.integer :child_facility_id, index: true
      t.timestamps
    end
  end
end
