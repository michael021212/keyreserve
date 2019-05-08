require 'rails_helper'

RSpec.feature 'corporation/information', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature 'お知らせ作成' do
    let(:shop) { create(:shop,
                        corporation: corporation,
                        name: 'とりせん') }

    let(:target_shop) { create(:shop,
                               corporation: corporation,
                               name: 'オータニ') }

    before do
      corporation_user
      shop
      target_shop
      login_user(user)
    end

    scenario 'お知らせを作成できる' do
      information_attributes = build(:information, info_target_type: :shop_users)
      
      visit corporation_manage_root_path

      click_on('お知らせ管理')
      click_on('新規追加')

      select 'とりせん', from: '送信元店舗'
      fill_in 'タイトル', with: information_attributes.title
      fill_in '詳細', with: information_attributes.description
      select_datetime('information', 'publish_time', Time.zone.local(2019, 10, 25, 10, 30))
      select information_attributes.info_type_i18n, from: 'お知らせ種別'
      select information_attributes.info_target_type_i18n, from: '配信対象'
      find('#information_shop_ids_2').click

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: 'お知らせを作成しました')
      expect(page).to have_css('.cy-information-title', text: information_attributes.title)
      expect(page).to have_css('.cy-information-description', text: information_attributes.description)
      expect(page).to have_css('.cy-information-publish-time', text: '2019年10月25日(金) 10:30')
      expect(page).to have_css('.cy-information-type', text: information_attributes.info_type_i18n)
      expect(page).to have_css('.cy-information-target-type', text: information_attributes.info_target_type_i18n)
      expect(page).to have_css('.cy-information-shops', text: 'オータニ')
    end
  end

  feature 'お知らせ編集' do
    let(:shop) { create(:shop,
                        corporation: corporation,
                        name: 'とりせん') }

    let(:target_shop) { create(:shop,
                               corporation: corporation,
                               name: 'オータニ') }

    let(:target_shop_2) { create(:shop,
                                 corporation: corporation,
                                 name: 'イオン') }

    let(:information) { create(:information,
                               shop: shop,
                               title: 'うちの店舗にきてください',
                               description: 'なんでも安くするのできてください',
                               publish_time: Time.zone.local(2019, 10, 25, 10, 30),
                               info_type: :event,
                               info_target_type: :shop_users)}

    before do
      corporation_user
      shop
      target_shop
      target_shop_2
      information
      login_user(user)
    end

    scenario 'お知らせを編集できる' do
      information_attributes = build(:information, info_target_type: :shop_users)
      
      visit corporation_manage_root_path

      click_on('お知らせ管理')

      within(find(".cy-information-#{information.id}")) do
        click_on('編集')
      end

      fill_in 'タイトル', with: information_attributes.title
      fill_in '詳細', with: information_attributes.description
      select_datetime('information', 'publish_time', Time.zone.local(2019, 12, 25, 15, 30))
      select information_attributes.info_type_i18n, from: 'お知らせ種別'
      select information_attributes.info_target_type_i18n, from: '配信対象'
      find('#information_shop_ids_1').click
      find('#information_shop_ids_2').click
      find('#information_shop_ids_3').click

      click_on('更新')

      expect(page).to have_css('.alert-warning', text: 'お知らせを更新しました')
      expect(page).to have_css('.cy-information-title', text: information_attributes.title)
      expect(page).to have_css('.cy-information-description', text: information_attributes.description)
      expect(page).to have_css('.cy-information-publish-time', text: '2019年12月25日(水) 15:30')
      expect(page).to have_css('.cy-information-type', text: information_attributes.info_type_i18n)
      expect(page).to have_css('.cy-information-target-type', text: information_attributes.info_target_type_i18n)
      expect(page).to have_css('.cy-information-shops', text: 'とりせん オータニ イオン')
    end
  end

  feature 'お知らせ削除' do
    let(:shop) { create(:shop, corporation: corporation) }

    let(:information) { create(:information, shop: shop)}

    before do
      corporation_user
      shop
      information
      login_user(user)
    end

    scenario 'お知らせを削除できる', js: true do
      visit corporation_manage_root_path

      click_on('お知らせ管理')

      within(find(".cy-information-#{information.id}")) do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css('.alert-warning', text: 'お知らせを削除しました')
      expect(page).not_to have_css(".cy-information-#{shop.id}")
    end
  end
end
