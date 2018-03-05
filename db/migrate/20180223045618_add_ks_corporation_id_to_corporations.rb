class AddKsCorporationIdToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :ks_corporation_id, :integer, default: nil, after: :token
  end
end
