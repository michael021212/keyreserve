class Reservation < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :facility
  belongs_to :user
  enum state: { unconfirmed: 0, confirmed: 1, canceled: 9 }

  scope :in_range, ->(range) do
    where(arel_table[:checkout].gteq(range.first)).where(arel_table[:checkin].lteq(range.last)) 
  end
  scope(:confirmed_to_i, -> { Reservation.states[:confirmed] })

  def self.new_from_spot(spot, card)
    checkin = DateTime.parse(spot[:checkin] + " " + spot[:checkin_time])
    Reservation.new(
      facility_id: spot[:facility_id],
      user_id: card.user_id,
      checkin: checkin,
    )
  end

  def self.to_csv(options)
    csv_data = CSV.generate(options) do |csv|
      csv << csv_column_names
      all.find_each do |row|
        csv << row.csv_column_values
      end
    end
    bom = "\xFF\xFE".dup.force_encoding('UTF-16LE')
    bom + csv_data.encode('UTF-16LE', undef: :replace, invalid: :replace, replace: '?', cr_newline: true)
  end

  def csv_column_values
    [
      facility.shop.corporation.name,
      facility.shop.name,
      facility.name,
      user.name,
      checkin.strftime('%Y/%m/%d %H:%M'),
      checkout.strftime('%Y/%m/%d %H:%M'),
      "#{usage_period}時間",
      state_i18n,
      "#{number_with_delimiter(price)}円"
    ]
  end

  def self.csv_column_names
    %w[運営会社名 店舗名 施設名 お名前 利用開始時間 利用終了時間 利用時間 状態 利用料金]
  end
end
