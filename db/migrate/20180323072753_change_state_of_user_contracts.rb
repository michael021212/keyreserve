class ChangeStateOfUserContracts < ActiveRecord::Migration[5.1]
  def change
    change_column :user_contracts, :state, :integer, default: 0, null: false, after: :finished_on
  end
end
