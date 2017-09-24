class CreateFacilities < ActiveRecord::Migration[5.1]
  def change
    create_table :facilities do |t|
      t.references :shop, null: false
      t.string :name, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
