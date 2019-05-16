require 'rails_helper'

RSpec.feature 'corporation_manage/facility_dropin_plans', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user, :corporate_admin) }
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
      temporary_plan_attributes = build(:facility_temporary_plan,
                                        facility: facility,
                                        plan: plan)
      
      visit corporation_manage_shop_facility_path(shop, facility)

      within(find('.cy-add-dropin-plan-btn')) do
        click_on('新規追加')
      end

      select temporary_plan_attributes.plan_name, from: 'プラン'
      fill_in '案内メールタイトル', with: temporary_plan_attributes.guide_mail_title
      fill_in '案内メール内容', with: temporary_plan_attributes.guide_mail_content

      click_on('追加')

      fill_in_with_script('.js-dropin-starting-time', '11:00')
      fill_in_with_script('.js-dropin-ending-time', '18:00')
      # NOTE: nested_fieldで追加される要素のIDが固定できないため下記の記法で対応
      find('.cy-dropin-price').set('10000')
      find('.cy-dropin-name').set('スーパープラン')

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '施設利用ドロップインプランを作成しました。')
      expect(page).to have_css('.fc-resource-cell', text: temporary_plan_attributes.plan_name)
      within('.fc-time-grid-event') do
        expect(page).to have_css('.fc-time', text: '11:00 - 18:00')
        expect(page).to have_css('.fc-title', text: "スーパープラン\n10,000 円")
      end
    end
  end
end
