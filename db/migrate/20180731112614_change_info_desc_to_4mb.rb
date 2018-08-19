class ChangeInfoDescTo4mb < ActiveRecord::Migration[5.1]
  def change
    change_column :information, :description, :text, limit: 4294967295
  end
end
