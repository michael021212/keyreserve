class CreateCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_cards do |t|
      t.references :user, null: false
      t.string :card_no, null: false
      t.integer :sequence
      t.integer :kind
      t.string :holder_name, null: false
      t.string :stripe_card_id
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
