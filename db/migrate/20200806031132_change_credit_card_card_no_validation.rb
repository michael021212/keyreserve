class ChangeCreditCardCardNoValidation < ActiveRecord::Migration[5.1]
  def up
    change_column :credit_cards, :card_no, :string, null: true
  end

  def down
    change_column :credit_cards, :card_no, :string, null: false
  end
end
