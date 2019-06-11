class AddSmsVerificationColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sms_verify_code, :integer
    add_column :users, :sms_sent_at, :datetime
    add_column :users, :sms_verified, :boolean, default: false
  end
end
