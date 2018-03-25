class Information < ApplicationRecord
  belongs_to :shop

  delegate :name, to: :shop, prefix: true, allow_nil: true

  validates :title, :description, :shop_id, presence: true
  validates :title, length: { maximum: 100, allow_blank: true }
  validates :description, length: { maximum: 512, allow_blank: true }

end
