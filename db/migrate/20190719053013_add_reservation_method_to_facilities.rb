class AddReservationMethodToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :reservation_type, :integer, default: 1
  end
end
