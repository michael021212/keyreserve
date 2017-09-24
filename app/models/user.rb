class User < ApplicationRecord
  acts_as_paranoid
  authenticates_with_sorcery!

  has_many :corporation_users
  accepts_nested_attributes_for :corporation_users
  has_many :corporations, through: :corporation_users

  enum state: { registered: 0, activated: 1 }
  enum payway: { creditcard: 1, invoice: 2 }

  validates :email, presence: true
  validates :email, email: true, length: { maximum: 255 }, allow_blank: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :tel, 
            presence: true, length: { maximum: 13 },
            numericality: { only_integer: true, allow_blank: true }
  validates :password, confirmation: true, presence:true, length: { minimum: 4, maximum: 20, allow_blank: true }, if: -> { new_record? || changes[:crypted_password] }
end
