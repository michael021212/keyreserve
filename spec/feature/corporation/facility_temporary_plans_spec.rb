require 'rails_helper'

RSpec.feature 'corporation_manage/facility_temporary_plans', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '都度課金プランの作成' do
    let(:shop) { create(:shop,
                        corporation: corporation,
                        opening_time: '10:00:00',
                        closing_time: '20:00:00') }
    let(:facility) { create(:facility, shop: shop) }
    let(:plan) { create(:plan,
                        corporation: corporation,
                        name: '西尾プラン')}
    let(:facility_key) { create(:facility_key,
                                facility: facility,
                                name: '西尾鍵') }

    before do
      corporation_user
      shop
      facility
      facility_key
      plan
      login_user(user)
    end

    scenario '都度課金プランを作成できる', js: true do
      allow(KeystationService).to receive(:sync_room_key_password).and_return('12345')
      temporary_plan_attributes = build(:facility_temporary_plan,
                                        facility: facility,
                                        plan: plan,
                                        standard_price_per_day: 10000,
                                        standard_price_per_hour: 1000)
      
      visit corporation_manage_shop_facility_path(shop, facility)

      within('.cy-add-temporary-plan-btn') do
        click_on('新規追加')
      end

      select temporary_plan_attributes.plan_name, from: 'プラン名'
      select '西尾鍵', from: '鍵'
      fill_in '案内メールタイトル', with: temporary_plan_attributes.guide_mail_title
      fill_in '案内メール内容', with: temporary_plan_attributes.guide_mail_content
      fill_in '標準価格（1日課金）', with: temporary_plan_attributes.standard_price_per_day
      fill_in '標準価格（時間課金）', with: temporary_plan_attributes.standard_price_per_hour

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '施設利用都度課金プランを作成しました。')
      expect(page).to have_css('.fc-resource-cell', text: temporary_plan_attributes.plan_name)
      expect(page).to have_css('.fc-day-grid-event', text: '10,000 円')
      within('.fc-time-grid-event') do
        expect(page).to have_css('.fc-time', text: '10:00 - 20:00')
        expect(page).to have_css('.fc-title', text: '1,000 円/h')
      end
    end
  end
end
