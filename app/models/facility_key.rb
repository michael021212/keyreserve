class FacilityKey < ApplicationRecord
  acts_as_paranoid

  before_save :set_name

  def set_name
    self.name = KeystationService.sync_room_key_name(ks_room_key_id) if ks_room_key_id.present?
  end

  def password
    KeystationService.sync_room_key_password(ks_room_key_id) if ks_room_key_id.present?
  end
end
