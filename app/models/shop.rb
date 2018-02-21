class Shop < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation

  geocoded_by :address, latitude: :lat, longitude: :lon
  before_validation :geocode
  validates :name, :address, :opening_time, :closing_time, presence: true
  validates :tel,
            length: { maximum: 13 },
            numericality: { only_integer: true, allow_blank: true }
end
