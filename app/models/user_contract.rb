class UserContract < ApplicationRecord
  belongs_to :corporation
  belongs_to :shop
  belongs_to :user
  belongs_to :plan
end
