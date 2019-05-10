require 'rails_helper'

RSpec.feature 'corporation/personal_identifications', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '本人確認用の書類の作成' do
    let(:target_user) { create(:user, name: '顧客ユーザー') }
    let(:corporation_user_2) { create(:corporation_user,
                                      user: target_user,
                                      corporation: corporation) }

    before do
      corporation_user
      corporation_user_2
      login_user(user)
    end

    scenario '本人確認用の書類を作成できる', js: true do
      visit corporation_manage_user_path(target_user)

      within('.cy-identification-btns') do
        click_on('新規追加')
      end

      select '未認証', from: '認証状態'
      select '運転免許証', from: '種別'
      attach_file '表面', Rails.root.join('spec/support/images/untenmenkyo.jpeg')
      attach_file '裏面', Rails.root.join('spec/support/images/untenmenkyo_uramen.jpg')

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '本人確認を作成しました。')
      expect(page).to have_css('.cy-identification-status', text: '未認証')
      expect(page).to have_css('.cy-identification-card-type', text: '運転免許証')
      expect(page).to have_css('.cy-identification-front-img')
      expect(page).to have_css('.cy-identification-back-img')
    end
  end
end
