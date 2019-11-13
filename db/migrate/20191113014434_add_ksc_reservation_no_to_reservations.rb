class AddKscReservationNoToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :ksc_reservation_no, :string
  end
end
