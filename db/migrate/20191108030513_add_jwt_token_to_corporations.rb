class AddJwtTokenToCorporations < ActiveRecord::Migration[5.1]
  def up
    add_column :corporations, :jwt_token, :string
  end

  def down
    remove_column :corporations, :jwt_token, :string
  end
end
