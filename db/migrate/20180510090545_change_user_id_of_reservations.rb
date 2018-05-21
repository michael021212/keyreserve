class ChangeUserIdOfReservations < ActiveRecord::Migration[5.1]
  def change
    change_column :reservations, :user_id, :integer, null: true,  after: :facility_id
  end
end
