class AddRememberMeAndResetPasswordToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remember_me_token, :string, :default => nil, after: :payway
    add_column :users, :remember_me_token_expires_at, :datetime, :default => nil, after: :remember_me_token
    add_column :users, :reset_password_token, :string, :default => nil, after: :remember_me_token_expires_at
    add_column :users, :reset_password_token_expires_at, :datetime, :default => nil, after: :reset_password_token
    add_column :users, :reset_password_email_sent_at, :datetime, :default => nil, after: :reset_password_token_expires_at

    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
  end
end
