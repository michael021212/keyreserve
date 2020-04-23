class AddNoteToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :note, :text
  end
end
