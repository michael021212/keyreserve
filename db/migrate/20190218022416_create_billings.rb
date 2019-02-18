class CreateBillings < ActiveRecord::Migration[5.1]
  def change
    create_table :billings do |t|
      t.references :corporation
      t.references :user
      t.integer :state, default: 1
      t.integer :price
      t.integer :month
      t.integer :year
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
