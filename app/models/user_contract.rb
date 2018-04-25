class UserContract < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  belongs_to :shop, optional: true
  belongs_to :user
  belongs_to :plan, optional: true

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :shop, prefix: true, allow_nil: true
  delegate :name, to: :plan, prefix: true, allow_nil: true

  enum state: { under_contract: 1, finished: 9 }

  validates :user_id, :started_on, :state, presence: true
  validate :contract_period

  def contract_period
    errors.add(:started_on, '契約開始日は契約終了日より早めにしてください') if started_on > finished_on
  end
end
