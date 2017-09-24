class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false
      t.references :corporation, null: false
      t.references :facility, null: false
      t.references :credit_card, null: false
      t.string :price, null: false
      t.string :token
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
