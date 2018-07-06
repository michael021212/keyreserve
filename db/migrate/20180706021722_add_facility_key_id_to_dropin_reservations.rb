class AddFacilityKeyIdToDropinReservations < ActiveRecord::Migration[5.1]
  def change
    add_reference :dropin_reservations, :facility_key, index: true, null: false, after: :facility_dropin_sub_plan_id
  end
end
