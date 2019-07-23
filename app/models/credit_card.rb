class CreditCard < ApplicationRecord
  acts_as_paranoid
  attr_accessor :number, :exp, :cvc
  belongs_to :user

  validates :number, :holder_name, presence: true
  validates :exp,
            presence: true,
            format: { with: /\A\d{2}\s\/\s\d{2}\z/ }
  validates :cvc,
            presence: true,
            numericality: { only_integer: true }

  enum kind: { visa: 1, master: 2 }

  def self.convert_brand2kind(brand)
    case(brand)
      when 'Visa' then kinds[:visa]
      when 'MasterCard' then kinds[:master]
    end
  end

  def prepare_stripe_card
    begin
      user.set_stripe_customer if user.stripe_customer_id.blank?
      stripe_card = stripe_card_id? ? update_stripe_card : create_stripe_card
      self.card_no = stripe_card.last4
      self.sequence = 1
      self.holder_name = stripe_card.name
      self.kind = self.class.convert_brand2kind(stripe_card.brand)
      self.stripe_card_id = stripe_card.id
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      raise e
    end
  end

  def create_stripe_card
    n = number.gsub(" ", "")
    em, ey = exp.gsub(" ", "").split("/")
    ey = '20' + ey
    token = Stripe::Token.create(
      card: {
        name: holder_name,
        number: n,
        exp_month: em,
        exp_year: ey,
        cvc: cvc
      }
    )
    stripe_customer = user.retrieve_stripe_customer
    stripe_customer.sources.create(source: token.id)
  end

  def update_stripe_card
    old_card_id = stripe_card_id
    card = create_stripe_card
    begin
      user.retrieve_stripe_customer.sources.retrieve(old_card_id).delete
    rescue => e
    end
    card
  end

  def full_card_no
    "XXXX XXXX XXXX #{card_no}"
  end
end
