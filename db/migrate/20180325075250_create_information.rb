class CreateInformation < ActiveRecord::Migration[5.1]
  def change
    create_table :information do |t|
      t.references :shop, index: true, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
