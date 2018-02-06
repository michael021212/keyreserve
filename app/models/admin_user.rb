class AdminUser < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  validates :name, :email, presence: true
  validates :email, email: true, length: { maximum: 255 }, uniqueness_without_deleted: true
  validates :password_digest, presence: true, length: { minimum: 8 }
end
