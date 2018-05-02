class AddPaymentIdToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :payment_id, :integer
  end
end
