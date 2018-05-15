class FacilityKey < ApplicationRecord
  acts_as_paranoid

  belongs_to :facility
  before_save :set_name

  scope(:selected, ->(c_id) { includes(facility: { shop: :corporation }).where(facilities: { shops: { corporations: { id: c_id } } }) })

  def set_name
    self.name = KeystationService.sync_room_key_name(ks_room_key_id) if ks_room_key_id.present?
  end

  def password
    KeystationService.sync_room_key_password(ks_room_key_id) if ks_room_key_id.present?
  end
end
