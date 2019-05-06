require 'rails_helper'

RSpec.feature 'corporation/personal_identifications', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '本人確認用の書類の作成' do
    let(:client_user) { create(:user, name: '顧客ユーザー') }
    let(:corporation_user_2) { create(:corporation_user,
                                      user: client_user,
                                      corporation: corporation) }

    before do
      corporation_user
      corporation_user_2
      login_user(user)
    end

    scenario '本人確認用の書類を作成できる', js: true do
      visit corporation_manage_user_path(client_user)

      within(find('.cy-identification-btns')) do
        click_on('登録')
      end

      select '未認証', from: '認証状態'
      select '運転免許証', from: '種別'
      attach_file '表面', Rails.root.join('spec/support/images/untenmenkyo.jpeg')
      attach_file '裏面', Rails.root.join('spec/support/images/untenmenkyo_uramen.jpg')

      click_on('登録')

      expect(find('.alert-warning')).to have_content('本人確認を登録しました。')
      expect(find('.cy-identification-status')).to have_content('未認証')
      expect(find('.cy-identification-card-type')).to have_content('運転免許証')
      expect(find('.cy-identification-front-img')['src']).to have_content('untenmenkyo.jpeg')
      expect(find('.cy-identification-back-img')['src']).to have_content('untenmenkyo_uramen.jpg')
    end
  end
end
