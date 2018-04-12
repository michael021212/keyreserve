class Information < ApplicationRecord
  belongs_to :shop, optional: true
  has_many :information_shops
  has_many :shops, through: :information_shops
  accepts_nested_attributes_for :information_shops, allow_destroy: true

  delegate :name, to: :shop, prefix: true, allow_nil: true

  enum info_type: { event: 1, important_notice: 2 }
  enum info_target_type: { all_users: 1, shop_users: 2 }

  validates :title, :description, presence: true
  validates :title, length: { maximum: 100, allow_blank: true }
  validates :description, length: { maximum: 512, allow_blank: true }
  validates :info_target_type, :info_type, :publish_time, presence: true

  scope(:ready_to_send, -> { where(mail_send_flag: false).where('publish_time <= ?', Time.zone.now) })
  scope(:enable_disp, -> {where('publish_time <= ?', Time.zone.now) })
end
