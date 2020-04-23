class AddVerificationRequiredToCorporations < ActiveRecord::Migration[5.1]
  def change
    add_column :corporations, :verification_required, :boolean, default: true
  end
end
