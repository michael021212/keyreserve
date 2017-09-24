class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.integer :state, null: false, default: 0
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
