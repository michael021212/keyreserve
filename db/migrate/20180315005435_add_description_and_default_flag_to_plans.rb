class AddDescriptionAndDefaultFlagToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :description, :text, after: :price
    add_column :plans, :default_flag, :boolean, default: false, after: :description
  end
end
