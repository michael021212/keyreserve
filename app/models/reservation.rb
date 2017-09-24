class Reservation < ApplicationRecord
  belongs_to :facility
  belongs_to :user
end
