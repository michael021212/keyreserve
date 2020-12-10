class AddCheckinTimeForStayToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :checkin_time_for_stay, :time
    add_column :facilities, :checkout_time_for_stay, :time
  end
end
