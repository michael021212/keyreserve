class Billing < ApplicationRecord
  has_many :reservations
  has_many :dropin_reservations
  has_many :billings
  belongs_to :user
  belongs_to :shop

  enum state: { unclaimed: 1, # 未請求
                claimed: 2 # 請求済
              }

  enum billing_type: { reservation: 1, # 未請求
                       dropin_reservation: 2 # 請求済
                     }

  # rakeタスクから月々の請求書データを作成するメソッド
  def self.create_monthly_billing!(year, month, price, shop_id, user_id, type, reservations)
    ActiveRecord::Base.transaction do
      billing = Billing.find_or_create_by!(shop_id: shop_id,
                                           user_id: user_id,
                                           price: price,
                                           month: month,
                                           billing_type: type,
                                           year: year)
      reservations.where(user_id: user_id).each{ |r| r.update!(billing_id: billing.id) }
    end
  end
end
