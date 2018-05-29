class AddGuideMailAndFileToFacilityTemporaryPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :facility_temporary_plans, :guide_mail, :text, default: nil, after: :ks_room_key_id
    add_column :facility_temporary_plans, :guide_file, :string, default: nil, after: :guide_mail
  end
end
