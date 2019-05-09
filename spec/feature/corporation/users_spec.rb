require 'rails_helper'

RSpec.feature 'corporation/users', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '利用者作成' do
    before do
      corporation
      user
      corporation_user
      login_user(user)
    end

    scenario '利用者を作成できる' do
      user_attributes = build(:user)
      
      visit corporation_manage_root_path

      click_on('利用者管理')

      within('.box-tools') do
        click_on('新規追加')
      end

      fill_in 'お名前', with: user_attributes.name
      fill_in 'メールアドレス', with: user_attributes.email
      fill_in '電話番号', with: user_attributes.tel
      select user_attributes.state_i18n, from: '状態'
      select user_attributes.payway_i18n, from: 'お支払い方法'
      fill_in 'パスワード', with: 'Password123'
      fill_in '確認用パスワード', with: 'Password123'

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '利用者を作成しました。')
      expect(page).to have_css('.cy-user-name', text: user_attributes.name)
      expect(page).to have_css('.cy-user-email', text: user_attributes.email)
      expect(page).to have_css('.cy-user-tel', text: user_attributes.tel)
      expect(page).to have_css('.cy-user-state', text: user_attributes.state_i18n)
      expect(page).to have_css('.cy-user-payway', text: user_attributes.payway_i18n)
    end
  end

  feature '利用者編集' do
    let(:target_user) { create(:user,
                               name: '吉岡里帆',
                               email: 'yoshioka@example.com',
                               tel: '08012311231',
                               state: :registered,
                               payway: :creditcard)}
    let(:corporation_user_2) { create(:corporation_user,
                                      user: target_user,
                                      corporation: corporation)}

    before do
      corporation
      user
      target_user
      corporation_user
      corporation_user_2
      login_user(user)
    end

    scenario '利用者を編集できる' do
      user_attributes = build(:user)
      
      visit corporation_manage_root_path

      click_on('利用者管理')

      within(".cy-user-#{target_user.id}") do
        click_on('編集')
      end

      fill_in 'お名前', with: user_attributes.name
      fill_in 'メールアドレス', with: user_attributes.email
      fill_in '電話番号', with: user_attributes.tel
      select user_attributes.state_i18n, from: '状態'
      select user_attributes.payway_i18n, from: 'お支払い方法'
      fill_in 'パスワード', with: 'Password123'
      fill_in '確認用パスワード', with: 'Password123'

      click_on('更新')

      expect(page).to have_css('.alert-warning', text: '利用者を更新しました。')
      expect(page).to have_css('.cy-user-name', text: user_attributes.name)
      expect(page).to have_css('.cy-user-email', text: user_attributes.email)
      expect(page).to have_css('.cy-user-tel', text: user_attributes.tel)
      expect(page).to have_css('.cy-user-state', text: user_attributes.state_i18n)
      expect(page).to have_css('.cy-user-payway', text: user_attributes.payway_i18n)
    end
  end

  feature '利用者削除' do
    context 'ユーザーがまだ契約を終えていなかった場合' do
      let(:target_user) { create(:user) }
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation) }
      let(:plan) { create(:plan) }
      let(:user_contract) { create(:user_contract,
                                   corporation: corporation,
                                   plan: plan,
                                   user: target_user) }
      
      before do
        corporation_user
        corporation_user_2
        user_contract
        login_user(user)
      end

      scenario '削除ボタンが表示されない' do
        visit corporation_manage_root_path

        click_on('利用者管理')

        within(".cy-user-#{target_user.id}") do
          expect(page).not_to have_content('削除')
        end
      end
    end

    context 'ユーザーが契約を終えている場合' do
      let(:target_user) { create(:user) }
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation) }
      let(:plan) { create(:plan) }
      let(:user_contract) { create(:user_contract,
                                   corporation: corporation,
                                   plan: plan,
                                   user: target_user,
                                   state: :finished) }

      before do
        corporation_user
        corporation_user_2
        user_contract
        login_user(user)
      end

      scenario 'ユーザーを削除できる', js: true do
        visit corporation_manage_root_path

        click_on('利用者管理')

        within(".cy-user-#{target_user.id}") do
          click_on('削除')
        end

        page.driver.browser.switch_to.alert.accept

        expect(page).to have_css('.alert-warning', text: '利用者を削除しました。')
        expect(page).not_to have_css(".cy-user-#{target_user.id}")
      end
    end
  end
end
