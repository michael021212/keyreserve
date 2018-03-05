class FacilityKey < ApplicationRecord
  acts_as_paranoid
  before_save :set_ks_room_key_info

  def set_ks_room_key_info
    name = KeystationService.sync_room_key_name(ks_room_key_id)
    password = KeystationService.sync_room_key_password(ks_room_key_id)
    self.key_id = ks_room_key_id
    self.name = name
    self.password = password
  end
end
