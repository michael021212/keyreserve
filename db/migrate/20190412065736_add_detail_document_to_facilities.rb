class AddDetailDocumentToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :detail_document, :string
    add_column :shops, :is_rent, :boolean, default: false
  end
end
