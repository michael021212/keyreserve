class CreateInformationShops < ActiveRecord::Migration[5.1]
  def change
    create_table :information_shops do |t|
      t.references :information, index: true, null: false
      t.references :shop, index: true, null: false
      t.timestamps
    end
  end
end
