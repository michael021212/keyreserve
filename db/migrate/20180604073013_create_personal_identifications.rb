class CreatePersonalIdentifications < ActiveRecord::Migration[5.1]
  def change
    create_table :personal_identifications do |t|
      t.references :user, null: false
      t.string :front_img, null: false
      t.string :back_img, default: nil
      t.integer :card_type, default: nil
      t.integer :status, default: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
