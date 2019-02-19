class Billing < ApplicationRecord
  has_many :reservations
  has_many :dropin_reservations
  has_many :billings
  belongs_to :user
  belongs_to :shop

  enum state: {
    unclaimed: 1, # 未請求
    claimed: 2    # 請求済
  }

  enum billing_type: {
    reservation: 1,       # 施設予約
    dropin_reservation: 2 # ドロップイン利用
  }

  enum payment_way: {
    credit_card: 1,     # クレカのみ
    invoice: 2,         # 請求書のみ
    card_and_invoice: 3 # クレカと請求書
  }

  scope :in_month, -> (year, month) do
    where('year = ? && month = ?', year, month)
  end
  scope :execlude_credit_card, -> do
    where.not(payment_way: Billing.payment_ways[:credit_card])
  end
  scope :execlude_invoice, -> do
    where.not(payment_way: Billing.payment_ways[:invoice])
  end

  # 渡されたデータを元に月々の請求書データを作成するメソッド
  def self.create_monthly_billing!(year, month, price, shop_id, user_id, type, billing_details)
    ActiveRecord::Base.transaction do
      payment_way = Billing.set_payment_way(reservations)
      billing = Billing.find_or_create_by!(shop_id: shop_id,
                                           user_id: user_id,
                                           price: price,
                                           month: month,
                                           payment_way: payment_way,
                                           billing_type: type,
                                           year: year)
      billing_details.where(user_id: user_id).each{ |r| r.update!(billing_id: billing.id) }
    end
  end

  # 請求に対する支払い方法を取得
  def self.set_payment_way(billing_details, way=0, default_value=0)
    billing_details.each do |d|
      if d.payment.present? && d.payment.credit_card_id.present?
        case way
        when default_value then way = Billing.payment_ways[:credit_card]
        when Billing.payment_ways[:invoice] then way = Billing.payment_ways[:card_and_invoice]
        end
      else
        case way
        when default_value then way = Billing.payment_ways[:invoice]
        when Billing.payment_ways[:credit_card] then way = Billing.payment_ways[:card_and_invoice]
        end
      end
    end
    way
  end

end
