class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.references :facility, null: false
      t.references :user, null: false
      t.datetime :checkin, null: false
      t.datetime :checkout, null: false
      t.integer :state, null: false, default: 0
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
