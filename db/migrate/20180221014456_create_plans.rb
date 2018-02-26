class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.references :corporation, null: false
      t.string :name, null: false
      t.integer :price, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
