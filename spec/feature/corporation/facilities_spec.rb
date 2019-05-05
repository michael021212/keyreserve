require 'rails_helper'

RSpec.feature 'corporation_manage/facilities', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }
  let(:shop) { create(:shop, corporation: corporation) }

  feature '施設作成' do
    let(:plan) { create(:plan,
                        name: 'お得プラン',
                        corporation: corporation) }

    before do
      corporation_user
      shop
      plan
      login_user(user)
    end

    scenario '施設を作成できる', js: true do
      visit corporation_manage_shop_path(shop)

      click_on('新規追加')

      VCR.use_cassette 'corporation_manage/facilities/new_facility_google_map' do
        fill_in '施設名', with: '西尾オフィス'
        fill_in '最大利用人数', with: 10
        fill_in '住所', with: '渋谷区宇田川町'
        select '会議室', from: '施設タイプ'
        fill_in '施設説明', with: '意識高い系の人たちが集まるオフィスなんだぜ'

        find('.cy-add-plan').click

        within(find('.cy-facility-plans')) do
          all('.cy-select-plan option[value="1"]')[0].select_option
        end

        click_on('登録')
      end

      expect(find('.alert-warning')).to have_content('施設を作成しました')
      expect(find('.cy-facility-name')).to have_content('西尾オフィス')
      expect(find('.cy-facility-max-num')).to have_content(10)
      expect(find('.cy-facility-address')).to have_content('渋谷区宇田川町')
      expect(find('.cy-facility-type')).to have_content('会議室')
      expect(find('.cy-facility-description')).to have_content('意識高い系の人たちが集まるオフィスなんだぜ')
      expect(find('.cy-facility-plans')).to have_content('お得プラン')
    end
  end

  feature '施設編集' do
    let(:plan) { create(:plan,
                        name: '天才プラン',
                        corporation: corporation) }
    let(:facility) { create(:facility,
                            shop: shop,
                            name: '西尾オフィス',
                            max_num: 10,
                            facility_type: :conference_room,
                            address: '渋谷区宇田川町')}

    before do
      corporation_user
      shop
      plan
      facility
      login_user(user)
    end

    scenario '施設を作成できる', js: true do
      visit corporation_manage_shop_path(shop)

      within(find(".cy-facility-#{facility.id}")) do
        click_on('編集')
      end

      VCR.use_cassette 'corporation_manage/facilities/edit_facility_google_map' do
        fill_in '施設名', with: '橋本オフィス'
        fill_in '最大利用人数', with: 100
        fill_in '住所', with: '六本木ヒルズ'
        select '賃貸物件', from: '施設タイプ'
        fill_in '施設説明', with: '柔術やってる人しか来れないんだぜ'

        find('.cy-add-plan').click

        within(find('.cy-facility-plans')) do
          all('.cy-select-plan option[value="1"]')[0].select_option
        end

        click_on('更新')
      end

      expect(find('.alert-warning')).to have_content('施設を更新しました')
      expect(find('.cy-facility-name')).to have_content('橋本オフィス')
      expect(find('.cy-facility-max-num')).to have_content(100)
      expect(find('.cy-facility-address')).to have_content('六本木ヒルズ')
      expect(find('.cy-facility-type')).to have_content('賃貸物件')
      expect(find('.cy-facility-description')).to have_content('柔術やってる人しか来れないんだぜ')
      expect(find('.cy-facility-plans')).to have_content('天才プラン')
    end
  end

  feature '施設削除' do
    let(:facility) { create(:facility, shop: shop) }

    before do
      corporation_user
      facility
      login_user(user)
    end

    scenario '施設を削除できる', js: true do
      visit corporation_manage_shop_facility_path(shop, facility)

      within(find('.box-tools')) do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(find('.alert-warning')).to have_content('施設を削除しました')
      expect(find('.cy-facilities-table')).not_to have_css(".cy-facility-#{shop.id}")
    end
  end

  feature '予約カレンダー' do
    let(:facility) { create(:facility, shop: shop) }
    let(:reservation) { create(:reservation,
                               facility: facility,
                               user: user,
                               payment: payment,
                               block_flag: true,
                               checkin: Time.zone.local(2019, 5, 20, 11, 00),
                               checkout: Time.zone.local(2019, 5, 20, 18, 00)) }

    before do
      corporation_user
      shop
      facility
      reservation
      login_user(user)
    end

    scenario '予約カレンダーが表示される', js: true do
      visit corporation_manage_shop_facility_path(shop, facility)

      move_to_target_date('#js-reservation-calendar', '2019-05-20')

      within(find('.fc-time-grid-event')) do
        expect(find('.fc-time')).to have_content('11:00 - 18:00')
        expect(find('.fc-title')).to have_content('ブロック')
      end
    end
  end
end
