class Information < ApplicationRecord
  belongs_to :shop, optional: true

  delegate :name, to: :shop, prefix: true, allow_nil: true

  enum info_type: { event: 1, important_notice: 2 }

  validates :title, :description, presence: true
  validates :title, length: { maximum: 100, allow_blank: true }
  validates :description, length: { maximum: 512, allow_blank: true }
end
