class AddParentColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_type, :integer, default: 1, after: :reset_password_email_sent_at
    add_column :users, :parent_id, :integer, after: :user_type
    add_column :users, :max_user_num, :integer, after: :parent_id
  end
end
