class CorporationUser < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :corporation

  accepts_nested_attributes_for :user
  delegate :name, to: :user, prefix: true, allow_nil: true
end
