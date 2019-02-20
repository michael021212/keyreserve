class ChangeReservationUsagePeriodType < ActiveRecord::Migration[5.1]
  def up
    change_column :reservations, :usage_period, :float
  end

  def down
    change_column :reservations, :usage_period, :integer
  end
end
