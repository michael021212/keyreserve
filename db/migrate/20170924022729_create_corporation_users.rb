class CreateCorporationUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :corporation_users do |t|
      t.references :corporation, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end
