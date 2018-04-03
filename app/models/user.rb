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
  validates :email, email: true, uniqueness: true
  validates :tel,
            presence: true, length: { maximum: 13 }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }

  scope(:is_corporation, -> { where(user_type: User.user_types[:corporation]) })
  scope(:has_parent, ->(parent_id) { where(parent_id: parent_id) })

  before_update :leave_parent, if: proc { |_user| user_type_was == 'corporation' && user_type == 'user' && max_user_num.present? }
  before_destroy :leave_parent, if: proc { |_user| user_type == 'corporation' && max_user_num.present? }
  before_save :change_user_type, if: proc { |_user| user_type_changed? && max_user_num.nil? }
  before_create :set_max_user_num, if: proc { |_user| corporation? && parent_id.nil? }
  before_create :convert_to_corporation, if: proc { |_user| user? && parent_id? }

  DEFAULT_MAX_USER_NUM = 5

  def leave_parent
    User.parent_users(id).where.not(id: parent_id).each do |user|
      user.update(user_type: 'user', parent_id: nil)
    end
    self.parent_id = nil
    self.max_user_num = nil
  end

  def change_user_type
    self.parent_id = nil if user_type_was == 'corporation' && user_type == 'user' && parent_id.present?
    if user_type_was == 'user' && user_type == 'corporation'
      self.parent_id = id
      self.max_user_num = DEFAULT_MAX_USER_NUM
    end
  end

  def set_parent_id
    self.parent_id = id
  end

  def convert_to_corporation
    self.user_type = :corporation
  end

  def set_max_user_num
    self.max_user_num = DEFAULT_MAX_USER_NUM
  end

  def self.parent_users(parent_id)
    is_corporation.has_parent(parent_id)
  end

  def parent
    return if parent_id.nil?
    User.find_by(parent_id: parent_id)
  end

  def add_new_user?
    return false if max_user_num.nil?
    try(:max_user_num) > User.parent_users(parent_id).count
  end

  def self.set_id_by_parent_token(parent_token)
    user = find_by(parent_token: parent_token)
    return unless user.parent.add_new_user?
    user.id
  end

  def available_facilities
    Facility.joins(:facility_plans)
            .where(facility_plans: { plan_id: user_contracts.under_contract.pluck(:plan_id) })
  end
end
