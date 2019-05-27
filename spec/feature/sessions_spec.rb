require 'rails_helper'

RSpec.feature 'sessions', type: :feature do
  feature 'ログイン' do
    context '施設管理者がログインした場合' do
      let(:user) { create(:user, :corporate_admin, password: 'Password#123') }
      let(:corporation) { create(:corporation) }
      let(:corporation_user) { create(:corporation_user,
                                      user: user,
                                      corporation: corporation) }

      before do
        corporation_user
      end

      scenario 'ログイン後の遷移先が運営会社管理画面になっている' do
        visit sign_in_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'Password#123'

        click_on('ログイン')

        expect(URI.parse(current_url).path).to eq(corporation_manage_root_path)
      end
    end

    context '普通のユーザーがログインした場合' do
      let(:user) { create(:user, password: 'Password#123') }

      scenario 'ログイン後の遷移先がTOP画面になっている' do
        visit sign_in_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'Password#123'

        click_on('ログイン')

        expect(URI.parse(current_url).path).to eq(root_path)
      end
    end
  end
end
