class Plan < ApplicationRecord
  acts_as_paranoid
  belongs_to :corporation

  validates :name, presence: true
  validates :price, presence: true, numericality: {only_integer: true}
end
