class AddSendMailFlagToReservations < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :mail_send_flag, :boolean, default: false
  end
end
