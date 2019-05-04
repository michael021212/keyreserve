require 'rails_helper'

RSpec.feature 'corporation_manage/facility_dropin_plans', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '施設利用ドロップインプランの作成' do
    let(:shop) { create(:shop,
                        corporation: corporation,
                        opening_time: '10:00:00',
                        closing_time: '20:00:00') }
    let(:facility) { create(:facility,
                            shop: shop,
                            facility_type: :dropin) }
    let(:plan) { create(:plan,
                        corporation: corporation,
                        name: '西尾プラン')}

    before do
      corporation_user
      shop
      facility
      plan
      login_user(user)
    end

    scenario '施設利用ドロップインプランを作成できる', js: true do
      visit corporation_manage_shop_facility_path(shop, facility)

      within(find('.cy-add-dropin-plan-btn')) do
        click_on('新規追加')
      end

      select '西尾プラン', from: 'プラン'
      fill_in '案内メールタイトル', with: '西尾プランですよー！'
      fill_in '案内メール内容', with: '西尾プランはすごいよー！'

      click_on('追加')

      fill_in_with_script('.js-dropin-starting-time', '11:00')
      fill_in_with_script('.js-dropin-ending-time', '18:00')
      # NOTE: cocoonで追加される要素のIDが固定できないため下記の記法で対応
      find('.cy-dropin-price').set('10000')
      find('.cy-dropin-name').set('スーパープラン')

      click_on('登録')

      expect(find('.alert-warning')).to have_content('施設利用ドロップインプランを作成しました。')
      expect(find('.fc-resource-cell')).to have_content('西尾プラン')
      within(find('.fc-time-grid-event')) do
        expect(find('.fc-time')).to have_content('11:00 - 18:00')
        expect(find('.fc-title')).to have_content("スーパープラン\n10,000 円")
      end
    end
  end
end
