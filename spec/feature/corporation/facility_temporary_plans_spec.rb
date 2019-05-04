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
      visit corporation_manage_shop_facility_path(shop, facility)

      within(find('.cy-add-temporary-plan-btn')) do
        click_on('新規追加')
      end

      select '西尾プラン', from: 'プラン名'
      select '西尾鍵', from: '鍵'
      fill_in '案内メールタイトル', with: '西尾プランですよー！'
      fill_in '案内メール内容', with: '西尾プランはすごいよー！'
      fill_in '標準価格（1日課金）', with: '10000'
      fill_in '標準価格（時間課金）', with: '1000'

      click_on('登録')

      expect(find('.alert-warning')).to have_content('施設利用都度課金プランを作成しました。')
      expect(find('.fc-resource-cell')).to have_content('西尾プラン')
      expect(find('.fc-day-grid-event')).to have_content('10,000 円')
      within(find('.fc-time-grid-event')) do
        expect(find('.fc-time')).to have_content('10:00 - 20:00')
        expect(find('.fc-title')).to have_content('1,000 円/h')
      end
    end
  end
end
