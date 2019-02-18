class Billing < ApplicationRecord
  has_many :reservations
  has_many :dropin_reservations
  belongs_to :user
  belongs_to :corporation

  enum state: { unclaimed: 1, # 未請求
                claimed: 2 # 請求済
              }
end
