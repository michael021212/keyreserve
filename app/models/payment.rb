class Payment < ApplicationRecord
  acts_as_paranoid

  include Target
  belongs_to :user
  belongs_to :facility
  belongs_to :credit_card

  before_create :stripe_charge
  before_destroy :stripe_cancel

  def stripe_charge
    begin
      ch = Stripe::Charge.create(
        amount: price,
        currency: 'jpy',
        customer: target.stripe_customer_id,
        capture: true
      )
    rescue StandardError => e
      logger.error(e)
    end
    self.token = ch.id
  end

  def stripe_cancel
    begin
      Stripe::Refund.create(
        charge: token
      )
    rescue StandardError => e
      logger.error(e)
    end
  end
end
