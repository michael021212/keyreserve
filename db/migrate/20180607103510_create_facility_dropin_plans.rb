class CreateFacilityDropinPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_dropin_plans do |t|
      t.references :facility, index: true, null: false
      t.integer :plan_id
      t.string :guide_mail_title
      t.text :guide_mail_content
      t.string :guide_file
      t.integer :usage_fee_per_hour
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
