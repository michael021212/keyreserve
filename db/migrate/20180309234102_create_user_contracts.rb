class CreateUserContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_contracts do |t|
      t.references :corporation, null: false, index: true
      t.references :shop, index: true
      t.references :user, null: false, index: true
      t.references :plan, null: false, index: true
      t.date :started_on, null: false
      t.date :finished_on
      t.integer :state, null: false, default: 1
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
