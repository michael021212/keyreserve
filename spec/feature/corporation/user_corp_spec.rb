require 'rails_helper'

RSpec.feature 'corporation/user_corps', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user, :corporate_admin) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '法人作成' do

    before do
      corporation_user
      login_user(user)
    end

    scenario '法人を作成できる', js: true do
      user_corp_attributes = build(:user_corp)

      visit corporation_manage_root_path

      click_on('法人管理')
      click_on('新規追加')

      fill_in '法人名', with: user_corp_attributes.name
      fill_in 'メールアドレス', with: user_corp_attributes.email
      fill_in '電話番号', with: user_corp_attributes.tel
      fill_in 'ご利用者様人数上限', with: user_corp_attributes.max_user_num
      fill_in 'パスワード', with: 'password123'
      fill_in '確認用パスワード', with: 'password123'

      click_on('登録')

      expect(page).to have_css('.alert-warning', text: '法人を作成しました。')
      expect(page).to have_css('.cy-user-corp-name', text: user_corp_attributes.name)
      expect(page).to have_css('.cy-user-corp-email', text: user_corp_attributes.email)
      expect(page).to have_css('.cy-user-corp-tel', text: user_corp_attributes.tel)
      expect(page).to have_css('.cy-user-corp-max-num', text: user_corp_attributes.max_user_num)
      expect(page).to have_css('.cy-user-corp-payway', text: user_corp_attributes.payway_i18n)
    end
  end

  feature '法人編集' do
    let(:target_user_corp) { create(:user_corp,
                                    name: '吉岡法人',
                                    email: 'yoshioka@example.com',
                                    tel: '08012311231')}
    let(:corporation_user_2) { create(:corporation_user,
                                      user: target_user_corp,
                                      corporation: corporation)}

    before do
      target_user_corp
      corporation_user
      corporation_user_2
      login_user(user)
    end

    scenario '法人を編集できる' do
      user_corp_attributes = build(:user_corp)

      visit corporation_manage_root_path

      click_on('法人管理')

      within(".cy-user-corp-#{target_user_corp.id}") do
        click_on('編集')
      end

      fill_in '法人名', with: user_corp_attributes.name
      fill_in 'メールアドレス', with: user_corp_attributes.email
      fill_in '電話番号', with: user_corp_attributes.tel
      fill_in 'ご利用者様人数上限', with: user_corp_attributes.max_user_num
      fill_in 'パスワード', with: 'password123'
      fill_in '確認用パスワード', with: 'password123'

      click_on('更新')

      expect(page).to have_css('.alert-warning', text: '法人を更新しました。')
      expect(page).to have_css('.cy-user-corp-name', text: user_corp_attributes.name)
      expect(page).to have_css('.cy-user-corp-email', text: user_corp_attributes.email)
      expect(page).to have_css('.cy-user-corp-tel', text: user_corp_attributes.tel)
      expect(page).to have_css('.cy-user-corp-max-num', text: user_corp_attributes.max_user_num)
      expect(page).to have_css('.cy-user-corp-payway', text: user_corp_attributes.payway_i18n)
    end
  end
end
