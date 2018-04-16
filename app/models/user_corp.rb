class UserCorp < User
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :users, foreign_key: :parent_id

  before_validation :set_corp_settings

  def set_corp_settings
    self.parent_id = nil
    pass = SecureRandom.hex(10)
    self.password = pass
    self.password_confirmation = pass
    self.email = SecureRandom.hex(10) + '@key-stations.jp'
    self.advertise_notice_flag = false
    self.user_type = :parent_corporation
  end
end
