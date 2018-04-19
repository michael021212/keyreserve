class UserContract < ApplicationRecord
  belongs_to :corporation
  belongs_to :shop, optional: true
  belongs_to :user
  belongs_to :plan

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :plan, prefix: true, allow_nil: true

  enum state: { under_contract: 1, finished: 9 }

  validates :user_id, :plan_id, :started_on, presence: true
end
