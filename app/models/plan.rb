class Plan < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation
  has_many :facility_plans, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true}
end
