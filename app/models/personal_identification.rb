class PersonalIdentification < ApplicationRecord
  acts_as_paranoid
  mount_uploader :front_img, FileUploader
  mount_uploader :back_img, FileUploader

  belongs_to :user

  validates :card_type, :front_img, presence: true

  enum card_type: { driver_license: 1, insurance_card: 2, my_number: 3, passport: 4, residence_card: 5, others: 9 }
  enum verified: { unconfirmed: 0, applying: 1, confirmed: 2 }
end
