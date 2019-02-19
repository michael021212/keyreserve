namespace :billing do
  desc "毎月の支払いデータを作成"
  task :create_monthly_billings => :environment do
    # テストデータ作る用にbaseの日付ずらしてタスク実行
    # base =  Time.zone.parse('2019-01-01 15:30:45')
    # from = base.beginning_of_month
    # to = base.end_of_month
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
          my_reservations = reservations.where(user_id: user_id)
          Billing.create_monthly_billing!(from.year,
                                          from.month,
                                          price,
                                          shop_id,
                                          user_id,
                                          :reservation,
                                          my_reservations)
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
          my_dropins = dropins.where(user_id: user_id)
          Billing.create_monthly_billing!(from.year,
                                          from.month,
                                          price,
                                          shop_id,
                                          user_id,
                                          :dropin_reservation,
                                          my_dropins)
        rescue => e
          puts e.inspect
        end
      end
    end

  end
end

