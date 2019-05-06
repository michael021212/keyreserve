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
      visit corporation_manage_root_path

      click_on('利用者管理')

      within(find('.box-tools')) do
        click_on('新規追加')
      end

      fill_in 'お名前', with: '橋本環奈'
      fill_in 'メールアドレス', with: 'hashimoto@example.com'
      fill_in '電話番号', with: '08012311231'
      select '登録済み', from: 'user[state]'
      select 'クレジットカード', from: 'user[payway]'
      fill_in 'パスワード', with: 'Password123'
      fill_in '確認用パスワード', with: 'Password123'

      click_on('登録')

      expect(find('.alert-warning')).to have_content('利用者を作成しました。')
      expect(find('.cy-user-name')).to have_content('橋本環奈')
      expect(find('.cy-user-email')).to have_content('hashimoto@example.com')
      expect(find('.cy-user-tel')).to have_content('08012311231')
      expect(find('.cy-user-state')).to have_content('登録済み')
      expect(find('.cy-user-payway')).to have_content('クレジットカード')
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
      visit corporation_manage_root_path

      click_on('利用者管理')

      within(find(".cy-user-#{target_user.id}")) do
        click_on('編集')
      end

      fill_in 'お名前', with: 'ジョンレノン'
      fill_in 'メールアドレス', with: 'jon@example.com'
      fill_in '電話番号', with: '07011111111'
      select '課金登録済み', from: 'user[state]'
      select '請求書', from: 'user[payway]'
      fill_in 'パスワード', with: 'Password123'
      fill_in '確認用パスワード', with: 'Password123'

      click_on('更新')

      expect(find('.alert-warning')).to have_content('利用者を更新しました。')
      expect(find('.cy-user-name')).to have_content('ジョンレノン')
      expect(find('.cy-user-email')).to have_content('jon@example.com')
      expect(find('.cy-user-tel')).to have_content('07011111111')
      expect(find('.cy-user-state')).to have_content('課金登録済み')
      expect(find('.cy-user-payway')).to have_content('請求書')
    end
  end

  feature '利用者削除' do
    context 'ログインしているユーザーの場合' do
      before do
        corporation
        user
        corporation_user
        login_user(user)
      end

      scenario '削除ボタンが表示されない' do
        visit corporation_manage_root_path

        click_on('利用者管理')

        within(find(".cy-user-#{user.id}")) do
          expect(page).not_to have_content('削除')
        end
      end
    end

    context 'ログインしているユーザー以外の場合' do
      let(:target_user) { create(:user)}
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation)}

      before do
        corporation
        user
        corporation_user
        corporation_user_2
        login_user(user)
      end

      scenario 'ユーザーを削除できる', js: true do
        visit corporation_manage_root_path

        click_on('利用者管理')

        within(find(".cy-user-#{target_user.id}")) do
          click_on('削除')
        end

        page.driver.browser.switch_to.alert.accept

        expect(find('.alert-warning')).to have_content('利用者を削除しました。')
        expect(page).not_to have_css(".cy-user-#{target_user.id}")
      end
    end
  end
end
