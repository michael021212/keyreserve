class Payment < ApplicationRecord
  acts_as_paranoid

  TAX_RATE = 1.10

  include Target
  belongs_to :user
  belongs_to :facility
  belongs_to :credit_card
  belongs_to :corporation, optional: true

  before_destroy :stripe_cancel

  def stripe_charge!
    charge = Stripe::Charge.create(
      amount: price,
      currency: 'jpy',
      customer: target.stripe_customer_id,
      capture: true
    )
    self.token = charge.id
    save!
  rescue Stripe::StripeError => e
    logger.error(e)
    raise
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
