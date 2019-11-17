class AddKsRoomIdToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :ks_room_id, :integer
  end
end
