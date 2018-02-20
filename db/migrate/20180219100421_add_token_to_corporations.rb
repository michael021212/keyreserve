class AddTokenToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :token, :string, default: nil, after: :note
  end
end
