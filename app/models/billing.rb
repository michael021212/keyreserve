class Billing < ApplicationRecord
  has_many :reservations
  has_many :dropin_reservations
  has_many :billings
  # 請求時に削除されている可能性もあるので、optional: trueを設定
  belongs_to :user, optional: true
  belongs_to :shop, optional: true

  enum state: {
    unclaimed: 1, # 未請求
    claimed: 2    # 請求済
  }

  enum payment_way: {
    credit_card: 1,     # クレカのみ
    invoice: 2,         # 請求書のみ
    card_and_invoice: 3 # クレカと請求書
  }
  
  delegate :name, to: :user, prefix: true
  delegate :name, to: :shop, prefix: true

  scope :in_month, -> (year, month) do
    where('year = ? && month = ?', year, month)
  end
  scope :execlude_credit_card, -> do
    where.not(payment_way: Billing.payment_ways[:credit_card])
  end
  scope :execlude_invoice, -> do
    where.not(payment_way: Billing.payment_ways[:invoice])
  end
  scope :target_shops, -> (shops_ids) { where(shop_id: shops_ids) }
  scope :year_month_eq, -> (year_month) {
    year = year_month.to_date.year
    month = year_month.to_date.month
    where(year: year, month: month)
  }

  # 請求時に削除済の施設も参照できる必要があったので上書き
  def user
    User.unscoped { super }
  end

  # 渡されたデータを元に月々の請求書データを作成するメソッド
  def self.create_monthly_billing!(year, month, price, shop_id, user_id, billing_details)
    ActiveRecord::Base.transaction do
      payment_way = Billing.set_payment_way(billing_details)
      billing = Billing.find_or_create_by!(shop_id: shop_id,
                                           user_id: user_id,
                                           price: price,
                                           month: month,
                                           payment_way: payment_way,
                                           year: year)
      billing_details.each{ |b| b.update!(billing_id: billing.id) }
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

  class << self
    def ransackable_scopes(auth_object = nil)
      [:year_month_eq]
    end
  end
end
