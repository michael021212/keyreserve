class CreateBillings < ActiveRecord::Migration[5.1]
  def change
    create_table :billings do |t|
      t.references :shop
      t.references :user
      t.integer :state, default: 1
      t.integer :payment_way
      t.integer :price
      t.integer :month
      t.integer :year
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
