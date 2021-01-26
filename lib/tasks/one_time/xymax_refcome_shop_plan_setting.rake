namespace :shop do
  desc 'ザイマックスとリフカムの店舗は専用プランを持つユーザーにしか公開されないようにする'
  task xymax_refcome_shop_plan_setting: :environment do
    Shop.find(22).update_attribute(:disclosure_range, 2)
    Shop.find(37).update_attribute(:disclosure_range, 2)
    ShopPlan.create(plan_id: 26, shop_id: 22)
    ShopPlan.create(plan_id: 30, shop_id: 37)
  end
end
