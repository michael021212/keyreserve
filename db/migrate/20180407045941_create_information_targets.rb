class CreateInformationTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :information_targets do |t|
      t.references :information, null: false, index: true
      t.references :shop,  null: false, index: true
      t.timestamps
    end
  end
end
