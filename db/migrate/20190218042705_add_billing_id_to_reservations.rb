class AddBillingIdToReservations < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservations, :billing, index: true
    add_reference :dropin_reservations, :billing, index: true
  end
end
