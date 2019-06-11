class AddKscTokenToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :ksc_token, :string
  end
end
