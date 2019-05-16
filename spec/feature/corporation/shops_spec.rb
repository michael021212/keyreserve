require 'rails_helper'

RSpec.describe 'corporation_manage/shops', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user, :corporate_admin) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '店舗作成' do
    before do
      corporation
      user
      corporation_user
      login_user(user)
    end

    scenario '店舗を作成できる', js: true do
      visit corporation_manage_root_path

      click_on('新規追加')

      VCR.use_cassette 'corporation_manage/shops/new_shop_google_map' do
        fill_in 'shop[name]', with: '西尾店舗'
        fill_in 'shop[postal_code]', with: '150-0042'
        fill_in 'shop[address]', with: '東京都渋谷区宇田川町３１−９'
        fill_in 'shop[tel]', with: '08012311231'
        fill_in_with_script('#shop_opening_time', '10:00')
        fill_in_with_script('#shop_closing_time', '20:00')
        fill_in 'shop[calendar_url]', with: 'https://www.fe-siken.com/'

        click_on('登録')
      end

      expect(find('.alert-warning')).to have_content('店舗を作成しました。')
      expect(find('.cy-shop-name')).to have_content('西尾店舗')
      expect(find('.cy-shop-postal-code')).to have_content('150-0042')
      expect(find('.cy-shop-address')).to have_content('東京都渋谷区宇田川町３１−９')
      expect(find('.cy-shop-tel')).to have_content('08012311231')
      expect(find('.cy-shop-opening-time')).to have_content('10:00')
      expect(find('.cy-shop-closing-time')).to have_content('20:00')
      within_frame(find('.iframe-box')) do
        expect(find('#header')).to have_content('基本情報技術者 試験情報＆徹底解説 -新制度に完全対応-')
      end
    end
  end

  feature '店舗編集' do
    let(:shop) { create(:shop,
                        corporation: corporation,
                        name: '西尾店舗',
                        postal_code: '150-0042',
                        address: '東京都渋谷区宇田川町３１−９',
                        tel: '08012311231',
                        opening_time: '10:00',
                        closing_time: '20:00',
                        calendar_url: 'https://www.fe-siken.com/') }

    before do
      corporation
      user
      shop
      corporation_user
      login_user(user)
    end

    scenario '店舗を編集できる', js: true do
      visit corporation_manage_root_path

      within(find(".cy-shop-#{shop.id}")) do
        click_on('編集')
      end

      VCR.use_cassette 'corporation_manage/shops/edit_shop_google_map' do
        fill_in 'shop[name]', with: '橋本店舗'
        fill_in 'shop[postal_code]', with: '110-0000'
        fill_in 'shop[address]', with: '東京都渋谷区'
        fill_in 'shop[tel]', with: '08010001000'
        fill_in_with_script('#shop_opening_time', '09:00')
        fill_in_with_script('#shop_closing_time', '21:00')
        fill_in 'shop[calendar_url]', with: 'https://www.ap-siken.com/'

        click_on('更新')
      end

      expect(find('.alert-warning')).to have_content('店舗を更新しました。')
      expect(find('.cy-shop-name')).to have_content('橋本店舗')
      expect(find('.cy-shop-postal-code')).to have_content('110-0000')
      expect(find('.cy-shop-address')).to have_content('東京都渋谷区')
      expect(find('.cy-shop-tel')).to have_content('08010001000')
      expect(find('.cy-shop-opening-time')).to have_content('09:00')
      expect(find('.cy-shop-closing-time')).to have_content('21:00')
      within_frame(find('.iframe-box')) do
        expect(find('#header')).to have_content('応用情報技術者 試験情報＆徹底解説')
      end
    end
  end

  feature '店舗削除' do
    let(:shop) { create(:shop, corporation: corporation) }

    before do
      corporation
      user
      shop
      corporation_user
      login_user(user)
    end

    scenario '店舗を削除できる', js: true do
      visit corporation_manage_root_path

      within(find(".cy-shop-#{shop.id}")) do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(find('.alert-warning')).to have_content('店舗を削除しました')
      expect(find('.corporation-shops-table')).not_to have_css(".cy-shop-#{shop.id}")
    end
  end
end
