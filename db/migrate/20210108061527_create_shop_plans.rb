class CreateShopPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_plans do |t|
      t.references :plan, foreign_key: true
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
