class Corporation < ApplicationRecord
  acts_as_paranoid

  has_many :corporation_users, dependent: :destroy
  has_many :users, through: :corporation_users
  has_many :user_corps, class_name: 'UserCorp',
                        through: :corporation_users,
                        source: :user
  has_many :corporate_admin_users, class_name: 'CorporateAdminUser',
                                   through: :corporation_users,
                                   source: :user
  has_many :plans, dependent: :destroy
  has_many :shops, dependent: :destroy
  has_many :user_contracts, dependent: :destroy

  accepts_nested_attributes_for :users

  validates :name, :kana, presence: true, length: { maximum: 255 }
  validates :tel, presence: true, length: { maximum: 255 }
  validates :postal_code, length: { maximum: 255 }
  validates :address, :note, length: { maximum: 255, allow_blank: true }

  before_save :generate_token_with_name

  # 企業毎のtoken生成
  def generate_token_with_name
    return if jwt_token.present?
    payload = { name: name, created_at: created_at, partner: true }
    token = JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
    self.jwt_token = token
  end

  def self.sync_from_api
    KeystationService.sync_corporations
  end

  def selectable_keys
    arrs = []
    KeystationService.sync_rooms(ks_corporation_id).each do |arr|
      ks_room_key_ids = FacilityKey.selected(self).pluck(:ks_room_key_id)
      next if ks_room_key_ids.include?(arr[1])
      arrs << arr
    end
    arrs
  end

  def plans_linked_with_user?(user)
    plans.ids.any? { |plan_id| user.contract_plan_ids.include?(plan_id) }
  end
end
