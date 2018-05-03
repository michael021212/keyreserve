class ChangeStripeCardId < ActiveRecord::Migration[5.1]
  def change
    remove_column :credit_cards, :stripe_card_id
    add_column :credit_cards, :stripe_card_id, :string, null: false, after: :holder_name
  end
end
