require 'rails_helper'

RSpec.describe 'corporation_manage/billings', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user, :corporate_admin) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }
  let(:shop) { create(:shop, corporation: corporation) }
  
  feature '請求一覧の検索', js: true do
    let(:billing) { create(:billing,
                           shop: shop,
                           user: user,
                           price: 1000,
                           year: 2019,
                           month: 10) }
    
    let(:billing_2) { create(:billing,
                             shop: shop,
                             user: user,
                             price: 1000,
                             year: 2019,
                             month: 3) }
    
    before do
      corporation_user
      billing
      billing_2
      login_user(user)
    end
    
    scenario '該当する年月の請求が表示される' do
      visit corporation_manage_root_path
      
      click_on('請求管理')
      
      fill_in_with_script('.monthPicker', '2019/10')
      
      click_on('検索')
      
      expect(page).to have_css(".cy-billing-#{billing.id}")
      expect(page).not_to have_css(".cy-billing-#{billing_2.id}")
    end
    
    scenario '該当しない年月の請求は表示されない' do
      visit corporation_manage_root_path
      
      click_on('請求管理')
      
      fill_in_with_script('.monthPicker', '2019/12')
      
      click_on('検索')
      
      expect(page).not_to have_css(".cy-billing-#{billing.id}")
      expect(page).not_to have_css(".cy-billing-#{billing_2.id}")
    end
    
    scenario 'デフォルトで先月の月の検索がかかっている' do
      travel_to(Date.new(2019, 4, 1)) do
        visit corporation_manage_root_path
        
        click_on('請求管理')
        
        expect(page).not_to have_css(".cy-billing-#{billing.id}")
        expect(page).to have_css(".cy-billing-#{billing_2.id}")
      end
    end
  end
  
  feature '請求詳細' do
    let(:facility) { create(:facility,
                            shop: shop,
                            name: 'ぺご施設')}
    let(:billing) { create(:billing,
                           shop: shop,
                           user: user,
                           price: 1000,
                           year: 2019,
                           month: 10) }
    let(:payment) { create(:payment,
                           user: user,
                           corporation: corporation,
                           facility: facility)}
    let(:reservation) { create(:reservation,
                               facility: facility,
                               user: user,
                               payment: payment,
                               checkin: Date.new(2019, 10, 20),
                               usage_period: 2.5,
                               state: :confirmed,
                               price: 10000,
                               billing: billing) }
    
    before do
      corporation_user
      billing
      reservation
      login_user(user)
    end
    
    scenario '請求の詳細が表示される' do
      visit corporation_manage_billing_path(billing)
      
      expect(page).to have_css('.cy-detail-time', text: '2019/10/20')
      expect(page).to have_css('.cy-detail-facility-name', text: 'ぺご施設')
      expect(page).to have_css('.cy-detail-usage-time', text: '2.5時間')
      expect(page).to have_css('.cy-detail-paid-type', text: 'クレジットカード')
      expect(page).to have_css('.cy-detail-price', text: '¥10,000')
    end
  end
end
