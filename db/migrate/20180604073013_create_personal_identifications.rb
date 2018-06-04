class CreatePersonalIdentifications < ActiveRecord::Migration[5.1]
  def change
    create_table :personal_identifications do |t|
      t.references :user, null: false
      t.string :files, null: false
      t.integer :type, default: nil
      t.boolean :verified, default: false 
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
