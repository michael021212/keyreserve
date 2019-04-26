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
      visit corporation_manage_root_path

      click_on('お知らせ管理')
      click_on('新規追加')

      select 'とりせん', from: '送信元店舗'
      fill_in 'タイトル', with: 'うちの店舗にきませんか？'
      fill_in '詳細', with: 'めちゃくちゃお肉が安いからみんなうちの店舗にきてね！！！'
      select_datetime('information', 'publish_time', DateTime.new(2019, 10,25,10,30))
      select 'イベントや告知', from: 'お知らせ種別'
      select '店舗契約者', from: '配信対象'
      find('#information_shop_ids_2').click

      click_on('登録')

      expect(find('.alert-warning')).to have_content('お知らせを作成しました')
      expect(find('.cy-information-title')).to have_content('うちの店舗にきませんか？')
      expect(find('.cy-information-description')).to have_content('めちゃくちゃお肉が安いからみんなうちの店舗にきてね！！！')
      expect(find('.cy-information-publish-time')).to have_content('2019年10月25日(金) 10:30')
      expect(find('.cy-information-type')).to have_content('イベントや告知')
      expect(find('.cy-information-target-type')).to have_content('店舗契約者')
      expect(find('.cy-information-shops')).to have_content('オータニ')
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
                               publish_time: DateTime.new(2019, 10,25,10,30),
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
      visit corporation_manage_root_path

      click_on('お知らせ管理')

      within(find(".cy-information-#{information.id}")) do
        click_on('編集')
      end

      fill_in 'タイトル', with: '蕎麦屋はじめました！！'
      fill_in '詳細', with: '蕎麦って美味しいですよね'
      select_datetime('information', 'publish_time', DateTime.new(2019, 12,25,15,30))
      select '重要なお知らせ', from: 'お知らせ種別'
      select '店舗契約者', from: '配信対象'
      find('#information_shop_ids_1').click
      find('#information_shop_ids_2').click
      find('#information_shop_ids_3').click

      click_on('更新')

      expect(find('.alert-warning')).to have_content('お知らせを更新しました')
      expect(find('.cy-information-title')).to have_content('蕎麦屋はじめました！！')
      expect(find('.cy-information-description')).to have_content('蕎麦って美味しいですよね')
      expect(find('.cy-information-publish-time')).to have_content('2019年12月25日(水) 15:30')
      expect(find('.cy-information-type')).to have_content('重要なお知らせ')
      expect(find('.cy-information-target-type')).to have_content('店舗契約者')
      expect(find('.cy-information-shops')).to have_content("とりせん オータニ イオン")
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

      expect(find('.alert-warning')).to have_content('お知らせを削除しました')
      expect(find('.table-striped')).not_to have_css(".cy-information-#{shop.id}")
    end
  end
end
