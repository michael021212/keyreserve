class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy

  accepts_nested_attributes_for :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }
  enum user_type: { personal: 1, parent_corporation: 2 }

  validates :name, :email, presence: true, length: { maximum: 255 }
  validates :email, email: true, uniqueness: true
  validates :tel,
            presence: true, length: { maximum: 13 }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }

  scope(:parent_corporation_users, ->(id) { where(parent_id: id) })
  scope(:exist_corporation_parents, -> { where.not(max_user_num: nil) })

  before_save :remove_parent_id, if: proc { |_user| user_type_was == 'parent_corporation' && user_type == 'personal' ||  max_user_num.present? }
  before_update :leave_parent_corporation, if: proc { |_user| user_type_was == 'parent_corporation' && user_type == 'personal' && max_user_num.present? }
  before_destroy :leave_parent_corporation, if: proc { |_user| parent_corporation? && max_user_num.present? }

  def remove_parent_id
    self.parent_id = nil
  end

  def set_parent_id
    self.parent_id = id
  end

  def self.parent_users(parent_id)
    parent_corporation.has_parent(parent_id)
  end

  def parent
    return if parent_id.nil?
    User.find_by(id: parent_id)
  end

  def available_facilities
    user ||= User.find(parent_id)
    Facility.joins(:facility_plans)
            .where(facility_plans: { plan_id: user.user_contracts.under_contract.pluck(:plan_id) })
  end

  def add_new_user?
    return false if max_user_num.nil?
    try(:max_user_num) > User.where(parent_id: id).count
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

  def self.has_contract_with_shop(shop_id)
    User.includes(user_contracts: :shop)
        .where(user_contracts: { shop_id: shop_id })
        .where.not(user_contracts: { state: UserContract.states[:finished] })
  end

  def self.set_id_by_parent_token(parent_token)
    user = find_by(parent_token: parent_token)
    return unless user.parent.add_new_user?
    user.id
  end

  private

  def leave_parent_corporation
    binding.pry
    return if User.parent_corporation_users(id).nil?
    User.parent_corporation_users(id).each do |user|
      user.update(user_type: 'personal', parent_id: nil)
    end
  end
end
