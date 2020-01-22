class AddCharteredToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :chartered, :boolean, default: false
  end
end
