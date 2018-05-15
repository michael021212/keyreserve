class AddKsRoomKeyIdToFacilityTemporaryPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :facility_temporary_plans, :ks_room_key_id, :integer, null: false, after: :plan_id
  end
end
