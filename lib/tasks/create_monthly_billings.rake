namespace :billing do
  desc "毎月の支払いデータを作成"
  task :create_monthly_billings => :environment do
    from = Time.zone.now.last_month.beginning_of_month
    to = Time.zone.now.last_month.end_of_month
    reservations_by_shop = Reservation
                           .in_range(from .. to)
                           .group_by{ |r| r.facility.shop_id }
    dropin_reservations_by_shop = DropinReservation
                                  .in_range(from .. to)
                                  .group_by{ |r| r.facility.shop_id }

    # 当月の会議室予約を店舗ごとに支払い登録
    reservations_by_shop.each do |shop_id, reservations|
      reservations = Reservation.where(id: reservations.map{ |r| r.id })
      user_id_with_price = reservations.group(:user_id).sum(:price).delete_if{ |r| r == nil }
      user_id_with_price.each do |user_id, price|
        begin
          Billing.create_monthly_billing!(from.year,
                                          from.month,
                                          price,
                                          shop_id,
                                          user_id,
                                          :reservation,
                                          reservations)
        rescue => e
          puts e.inspect
        end
      end
    end

    # 当月のドロップイン予約を店舗ごとに支払い登録
    dropin_reservations_by_shop.each do |shop_id, dropins|
      dropins = DropinReservation.where(id: dropins.map{ |r| r.id })
      user_id_with_price = dropins.group(:user_id).sum(:price).delete_if{ |r| r == nil }
      user_id_with_price.each do |user_id, price|
        begin
          Billing.create_monthly_billing!(from.year,
                                          from.month,
                                          price,
                                          shop_id,
                                          user_id,
                                          :dropin_reservation,
                                          dropins)
        rescue => e
          puts e.inspect
        end
      end
    end

  end
end

