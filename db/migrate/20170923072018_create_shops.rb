class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.references :corporation, null: false
      t.string :name, null: false
      t.string :postal_code
      t.string :address
      t.decimal :lat, precision: 11, scale: 8
      t.decimal :lon, precision: 11, scale: 8
      t.string :tel
      t.time :opening_time, null: false
      t.time :closing_time, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
