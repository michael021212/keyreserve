class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  attr_accessor :corporation_id

  has_many :corporation_users, dependent: :destroy
  has_many :corporations, through: :corporation_users
  has_many :user_contracts, dependent: :destroy
  has_many :reservations
  has_many :dropin_reservations
  has_many :payments
  has_many :belongs_users, foreign_key: :parent_id, class_name: 'User'
  has_one :credit_card, dependent: :destroy
  has_one :personal_identification, dependent: :destroy

  belongs_to :user_corp, foreign_key: :parent_id, optional: true
  delegate :name, to: :user_corp, prefix: true, allow_nil: true
  delegate :id, to: :credit_card, prefix: true, allow_nil: true
  has_many :billings

  accepts_nested_attributes_for :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }
  enum user_type: { personal: 1, parent_corporation: 2, corporate_admin: 3, ks_flexible: 4 }
  enum browsable_range: { related_corp_facilities: 0, all_facilities: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, email: true, uniqueness: true, if: Proc.new { |u| u.personal? }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }
  validates_acceptance_of :term_of_use, allow_nil: false, on: :new_user_registration

  scope(:user_corp_token, ->(token) { find_by(parent_token: token) })
  scope(:parent_is_nil, -> { where(parent_id: nil) })

  def skip_sms_verification_if_not_required!
    return if corporations.blank? || !corporations.pluck(:verification_required).include?(false)
    update!(sms_verified: true)
  end

  # 利用可能な施設一覧
  # ユーザが契約中のプランに紐付いてる施設一覧
  def available_facilities
    Facility.joins(:facility_plans)
            .where(facility_plans: {plan_id: user_contracts.under_contract.pluck(:plan_id)})
  end

  def add_new_user?
    return false if max_user_num.nil?
    try(:max_user_num) > User.where(parent_id: id).count
  end

  def self.has_contract_with_shops(shop_ids)
    User.includes(user_contracts: :shop)
        .where(user_contracts: { shop_id: shop_ids })
        .where.not(user_contracts: { state: UserContract.states[:finished] })
  end

  def self.selectable_user_contracts
    User.personal.parent_is_nil.or(User.parent_corporation)
  end

  # 利用者の契約で都度課金が可能な施設の一覧
  def login_spots
    plan_ids = self.user_contracts.map(&:plan_id)
    facility_ids = FacilityTemporaryPlan.where(plan_id: plan_ids).map(&:facility_id)
    Facility.where(id: facility_ids).or(Facility.logout_spots)
  end

  def login_dropin_spots
    plan_ids = self.user_contracts.map(&:plan_id)
    facility_ids = FacilityDropinPlan.where(plan_id: plan_ids).map(&:facility_id)
    Facility.where(id: facility_ids).or(Facility.logout_dropin_spots)
  end

  def member_facility_dropin_sub_plan
    plan_ids = [nil]
    plan_ids << self.user_contracts.map(&:plan_id)
    FacilityDropinPlan.where(plan_id: plan_ids).pluck(:facility_id)
  end

  # stripeのユーザを新規作成して、customer_idをuserに保存
  def set_stripe_customer
    stripe_customer = Stripe::Customer.create(email: email)
    assign_attributes(stripe_customer_id: stripe_customer.id)
  end

  # stripeユーザの情報取得
  def retrieve_stripe_customer
    return if stripe_customer_id.blank?
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def name_with_corp
    user_corp.present? ? "(#{user_corp.name}) #{name}" : name
  end

  def deletable?
    user_contracts.all?(&:finished?) && reservations.all?(&:deletable?) && dropin_reservations.all?(&:deletable?)
  end

  def contract_plan_ids
    user_contracts.present? ? user_contracts.map(&:plan_id) : []
  end

  def is_ks_member?
    corporate_admin? && corporations.pluck(:id).include?(Corporation::KEYSTATION_ID)
  end
end
