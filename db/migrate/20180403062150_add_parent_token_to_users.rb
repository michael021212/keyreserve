class AddParentTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :parent_token, :string, after: :parent_id
  end
end
