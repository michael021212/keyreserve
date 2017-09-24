class AdminUser < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :email, email: true, length: { maximum: 255 }, allow_blank: true
  validates :password_digest, presence: true, length: { minimum: 8 }
end
