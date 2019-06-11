class CorporateAdminUser < User
  default_scope { where(user_type: :corporate_admin) }

  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, foreign_key: :user_id, dependent: :destroy, inverse_of: :user
  has_many :corporations, through: :corporation_users

  validates :email, email: true, uniqueness: true
  accepts_nested_attributes_for :corporation_users
end
