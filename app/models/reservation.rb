class Reservation < ApplicationRecord
  belongs_to :facility
  belongs_to :user

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gteq(range.first)).where(arel_table[:checkin].lteq(range.last)) 
  end

end
