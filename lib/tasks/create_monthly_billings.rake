namespace :billing do
  desc "毎月の支払いデータを作成"
  task :create_monthly_billings => :environment do
    # テストデータ作る用にbaseの日付ずらしてタスク実行
    base =  Time.zone.parse('2019-01-01 15:30:45')
    from = base.beginning_of_month
    to = base.end_of_month
    #from = Time.zone.now.last_month.beginning_of_month
    #to = Time.zone.now.last_month.end_of_month
    reservations_by_user = Reservation
                           .in_range(from .. to)
                           .group_by{ |r| r.user_id }
    dropin_reservations_by_user = DropinReservation
                                  .in_range(from .. to)
                                  .group_by{ |r| r.user_id }
    objects_by_user = reservations_by_user
                      .merge(dropin_reservations_by_user) { |key, h1, h2| h1 + h2 }
                      .delete_if{ |k,v| k == nil }

    objects_by_user.each do |user_id, objects|
      # 支払い先が一箇所の場合
      if objects.map{ |o| o.facility.shop.id }.uniq.count == 1
        price = 0
        objects.each{ |o| price += o.price }
        shop_id = objects.first.facility.shop.id
        begin
          Billing.create_monthly_billing!(from.year,
                                          from.month,
                                          price,
                                          shop_id,
                                          user_id,
                                          objects)
        rescue => e
          puts e.inspect
        end
      # 支払先が複数店舗ある場合
      else
        objects_by_shop = objects.group_by{ |o| o.facility.shop.id }
        objects_by_shop.each do |shop_id, objects_by_user_and_shop|
          price = 0
          objects_by_user_and_shop.each{ |o| price += o.price }
          begin
            Billing.create_monthly_billing!(from.year,
                                            from.month,
                                            price,
                                            shop_id,
                                            user_id,
                                            objects_by_user_and_shop)
          rescue => e
            puts e.inspect
          end
        end
      end
    end
  end
end

