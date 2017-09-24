class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
      t.string :name, null: false
      t.string :tel
      t.integer :state, null: false, default: 0
      t.integer :payway, null: false, default: 1
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
