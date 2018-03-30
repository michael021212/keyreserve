class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy

  accepts_nested_attributes_for :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }
  enum user_type: { user: 1, corporation: 2 }

  validates :name, :email, presence: true, length: { maximum: 255 }
  validates :email, email: true
  validates :tel,
            presence: true, length: { maximum: 13 }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }

  scope(:is_user, -> { where(user_type: User.user_types[:user]) })
  scope(:with_parent, ->(parent_id) { where(parent_id: parent_id) })

  # before_update :leave_parent, if: :become_user

  def available_facilities
    Facility.joins(:facility_plans)
      .where(facility_plans: {plan_id: user_contracts.under_contract.pluck(:plan_id)})
  end

  def self.belong_to_parent(parent_id)
    is_user.with_parent(parent_id)
  end

  def parent
    return if parent_id.nil? || corporation?
    User.find_by(parent_id: parent_id)
  end

  def become_user
    user_type_was == 'corporation' && user_type == 'user'
  end

  def leave_parent
  end
end
