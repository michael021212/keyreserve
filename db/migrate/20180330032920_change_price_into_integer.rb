class ChangePriceIntoInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :payments, :price, :integer, after: :credit_card_id 
  end
end
