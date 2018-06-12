class CreateDropinReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :dropin_reservations do |t|
      t.references :facility, index: true, null: false
      t.references :facility_dropin_plan, index: true, null: false
      t.references :facility_dropin_sub_plan, index: true, null: false
      t.integer :user_id
      t.integer :reservation_user_id
      t.integer :payment_id
      t.datetime :checkin
      t.datetime :checkout
      t.integer :state, default: 0
      t.integer :price, default: 0
      t.boolean :block_flag, default: false
      t.boolean :mail_send_flag, default: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
