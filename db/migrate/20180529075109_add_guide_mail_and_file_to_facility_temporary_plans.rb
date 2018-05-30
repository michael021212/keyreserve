class AddGuideMailAndFileToFacilityTemporaryPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :facility_temporary_plans, :guide_mail_title, :string, default: nil, after: :ks_room_key_id
    add_column :facility_temporary_plans, :guide_mail_content, :text, default: nil, after: :guide_mail_title
    add_column :facility_temporary_plans, :guide_file, :string, default: nil, after: :guide_mail_content
  end
end
