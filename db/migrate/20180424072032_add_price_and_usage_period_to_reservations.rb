class AddPriceAndUsagePeriodToReservations < ActiveRecord::Migration[5.1]
  def change
    change_column :reservations, :checkin, :datetime, null: true, after: :user_id
    change_column :reservations, :checkout, :datetime, null: true, after: :checkin
    add_column :reservations, :usage_period, :integer, null: true, after: :checkout
    add_column :reservations, :price, :integer, default: 0, null: false, after: :state
  end
end
