require 'rails_helper'

RSpec.feature 'corporation/corporate_admin_users', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user, :corporate_admin) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '施設管理者作成' do
    before do
      corporation_user
      login_user(user)
    end

    scenario '施設管理者を作成できる' do
      corporate_admin_user_attributes = build(:corporate_admin_user)

      visit corporation_manage_root_path

      click_on('施設管理者管理')
      click_on('新規追加')

      fill_in '施設管理者名', with: corporate_admin_user_attributes.name
      fill_in 'メールアドレス', with: corporate_admin_user_attributes.email
      fill_in '電話番号', with: corporate_admin_user_attributes.tel
      fill_in 'パスワード', with: 'password123'
      fill_in '確認用パスワード', with: 'password123'

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '施設管理者を作成しました。')
      expect(page).to have_css('.cy-corporate-admin-user-name', text: corporate_admin_user_attributes.name)
      expect(page).to have_css('.cy-corporate-admin-user-email', text: corporate_admin_user_attributes.email)
      expect(page).to have_css('.cy-corporate-admin-user-tel', text: corporate_admin_user_attributes.tel)
    end
  end

  feature '施設管理者編集' do
    let(:target_corporate_admin_user) { create(:corporate_admin_user,
                                               name: '吉岡施設管理者',
                                               email: 'yoshioka@example.com',
                                               tel: '08012311231')}
    let(:corporation_user_2) { create(:corporation_user,
                                      user: target_corporate_admin_user,
                                      corporation: corporation)}

    before do
      target_corporate_admin_user
      corporation_user
      corporation_user_2
      login_user(user)
    end

    scenario '施設管理者を編集できる' do
      corporate_admin_user_attributes = build(:corporate_admin_user)

      visit corporation_manage_root_path

      click_on('施設管理者管理')

      within(".cy-corporate-admin-user-#{target_corporate_admin_user.id}") do
        click_on('編集')
      end

      fill_in '施設管理者名', with: corporate_admin_user_attributes.name
      fill_in 'メールアドレス', with: corporate_admin_user_attributes.email
      fill_in '電話番号', with: corporate_admin_user_attributes.tel
      fill_in 'パスワード', with: 'password123'
      fill_in '確認用パスワード', with: 'password123'

      click_on('更新')

      expect(page).to have_css('.alert-warning', text: '施設管理者を更新しました。')
      expect(page).to have_css('.cy-corporate-admin-user-name', text: corporate_admin_user_attributes.name)
      expect(page).to have_css('.cy-corporate-admin-user-email', text: corporate_admin_user_attributes.email)
      expect(page).to have_css('.cy-corporate-admin-user-tel', text: corporate_admin_user_attributes.tel)
    end
  end
end
