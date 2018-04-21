class ChangePlanIdOfUserContracts < ActiveRecord::Migration[5.1]
  def change
    change_column :user_contracts, :plan_id, :integer, null: true,  after: :user_id
  end
end
