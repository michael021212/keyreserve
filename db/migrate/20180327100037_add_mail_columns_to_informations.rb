class AddMailColumnsToInformations < ActiveRecord::Migration[5.1]
  def change
    change_column :information, :shop_id, :integer, null: true, after: :id
    add_column :information, :publish_time, :datetime, null: false, after: :description
    add_column :information, :mail_send_flag, :boolean, default: false, after: :publish_time
    add_column :information, :info_type, :integer, default: 1, null: false, after: :mail_send_flag
  end
end
