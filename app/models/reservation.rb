class Reservation < ApplicationRecord
  belongs_to :facility
  belongs_to :user

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gteq(range.first)).where(arel_table[:checkin].lteq(range.last)) 
  end

  def self.new_from_spot(spot, card)
    checkin = DateTime.parse(spot[:checkin] + " " + spot[:checkin_time])
    Reservation.new(
      facility_id: spot[:facility_id],
      user_id: card.user_id,
      checkin: checkin,
    )
  end

end
