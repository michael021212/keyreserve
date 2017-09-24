class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :corporation
  belongs_to :facility
  belongs_to :credit_card
end
