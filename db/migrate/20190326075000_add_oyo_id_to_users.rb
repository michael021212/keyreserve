class AddOyoIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :campaign_id, :string
  end
end
