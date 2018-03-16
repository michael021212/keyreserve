class Shop < ApplicationRecord
  acts_as_paranoid
  mount_uploader :image, ImageUploader

  belongs_to :corporation
  has_many :facilities, dependent: :destroy

  geocoded_by :address, latitude: :lat, longitude: :lon
  before_validation :geocode
  validates :name, :opening_time, :closing_time, presence: true
  validates :tel,
            length: { maximum: 13 },
            numericality: { only_integer: true, allow_blank: true }
end
