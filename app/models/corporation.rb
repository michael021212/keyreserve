class Corporation < ApplicationRecord
  acts_as_paranoid
  has_many :corporation_users
  has_many :users, through: :corporation_users
  accepts_nested_attributes_for :users

  validates :name, presence: true, length: { maximum: 255 }
  validates :kana, presence: true, length: { maximum: 255 }
  validates :tel, presence: true, length: { maximum: 255 }
  validates :postal_code, length: { maximum: 255 }
  validates :address, length: { maximum: 255, allow_blank: true }
  validates :note, length: { maximum: 255, allow_blank: true }
end
