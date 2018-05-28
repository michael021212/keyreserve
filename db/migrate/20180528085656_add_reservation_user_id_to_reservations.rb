class AddReservationUserIdToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :reservation_user_id, :integer, default: nil, after: :user_id
  end
end
