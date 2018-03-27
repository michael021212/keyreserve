class AddAdvertiseNoticeFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :advertise_notice_flag, :boolean, default: true, after: :reset_password_email_sent_at
  end
end
