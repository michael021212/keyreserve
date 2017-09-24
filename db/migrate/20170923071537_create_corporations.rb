class CreateCorporations < ActiveRecord::Migration[5.1]
  def change
    create_table :corporations do |t|
      t.string :name, null: false
      t.string :kana, null: false
      t.string :tel, null: false
      t.string :postal_code
      t.string :address
      t.text :note
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
