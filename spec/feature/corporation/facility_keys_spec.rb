require 'rails_helper'

RSpec.feature 'corporation_manage/facility_keys', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }
  let(:shop) { create(:shop, corporation: corporation) }
  let(:facility) { create(:facility, shop: shop)}

  feature '施設鍵作成' do

    before do
      corporation_user
      login_user(user)
    end

    scenario '施設鍵を登録できる', js: true do
      allow(KeystationService).to receive(:sync_rooms).and_return([["テスト鍵", 1], ["テスト鍵２", 2]])
      allow(KeystationService).to receive(:sync_room_key_name).and_return('テスト鍵')
      allow(KeystationService).to receive(:sync_room_key_password).and_return('12345')

      visit corporation_manage_shop_facility_path(shop, facility)

      find('.cy-add-facility-key').click

      select 'テスト鍵', from: '鍵'

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '施設鍵を作成しました')
      expect(page).to have_css('.cy-key-name', text: 'テスト鍵')
      expect(page).to have_css('.cy-key-password', text: '12345')
    end
  end
end
