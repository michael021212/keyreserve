class UserContract < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  belongs_to :shop, optional: true
  belongs_to :user
  belongs_to :plan, optional: true

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :shop, prefix: true, allow_nil: true
  delegate :name, to: :plan, prefix: true, allow_nil: true

  enum state: { applying: 0, under_contract: 1, finished: 9 }

  validates :user_id, :plan_id, :started_on, :state, presence: true
end
