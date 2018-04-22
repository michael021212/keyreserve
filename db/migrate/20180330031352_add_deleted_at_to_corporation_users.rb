class AddDeletedAtToCorporationUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :corporation_users, :deleted_at, :datetime, null: true, after: :updated_at
  end
end
