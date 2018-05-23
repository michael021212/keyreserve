class AddBlockFlagToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :block_flag, :boolean, default: false, after: :price
  end
end
