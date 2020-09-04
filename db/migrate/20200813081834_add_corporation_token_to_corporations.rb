class AddCorporationTokenToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :corporation_token, :string
  end
end
