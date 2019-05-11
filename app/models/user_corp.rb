class UserCorp < User
  default_scope { where(user_type: :parent_corporation) }

  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, foreign_key: :user_id, dependent: :destroy, inverse_of: :user
  has_many :corporations, through: :corporation_users
  has_many :users, foreign_key: :parent_id

  accepts_nested_attributes_for :corporation_users

  before_destroy :remove_parent_id

  def set_corp_settings
    self.parent_id = nil
    pass = SecureRandom.hex(10)
    self.password = pass
    self.password_confirmation = pass
    self.advertise_notice_flag = false
    self.user_type = :parent_corporation
  end

  def remove_parent_id
    users.each do |user|
      user.update(parent_id: nil)
    end
  end
end
