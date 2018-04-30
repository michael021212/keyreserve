class AddUseHoursToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :use_hours, :integer, default: 0
  end
end
