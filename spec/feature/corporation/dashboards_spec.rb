require 'rails_helper'

RSpec.feature 'corporation/dashboards', type: :feature do

  feature '運営会社ダッシュボード' do
    let(:corporation) { create(:corporation,
                               name: '西尾会社',
                               kana: 'サイオカイシャ',
                               tel: '08012331233',
                               postal_code: '133-1231',
                               address: '東京都 渋谷区 宇田川1-1-19',
                               note: 'アップルを超える会社なんだぜ。') }

    context '運営会社に紐づくユーザーが存在する場合' do
      let(:user) { create(:user, :corporate_admin) }
      let(:corporation_user) { create(:corporation_user,
                                      user: user,
                                      corporation: corporation) }

      before do
        corporation_user
        login_user(user)
      end

      scenario '運営会社のダッシュボードにアクセスできる' do
        visit root_path

        within('.navbar-inverse') do
          click_on('運営会社管理')
        end

        expect(page).to have_css('.logo-lg', text: '西尾会社')
        expect(page).to have_css('.cy-corporation-name', text: '西尾会社')
        expect(page).to have_css('.cy-corporation-kana', text: 'サイオカイシャ')
        expect(page).to have_css('.cy-corporation-tel', text: '08012331233')
        expect(page).to have_css('.cy-corporation-kana', text: 'サイオカイシャ')
        expect(page).to have_css('.cy-corporation-postal-code', text: '133-1231')
        expect(page).to have_css('.cy-corporation-note', text: 'アップルを超える会社なんだぜ。')
      end
    end
    
    context '普通のユーザーがどこかの運営会社と紐づいていた場合' do
      let(:user) { create(:user, user_type: :personal) }
      let(:corporation_user) { create(:corporation_user,
                                      user: user,
                                      corporation: corporation) }
  
      before do
        corporation_user
        login_user(user)
      end
  
      scenario 'ヘッダーに「運営管理」が表示されない' do
        visit root_path
        expect(page).not_to have_css('.navbar-inverse', text: '運営会社管理')
      end
  
      scenario 'URL直打ちでもアクセスできない' do
        visit corporation_manage_root_path
        expect(page).to have_css('.alert-warning', text: 'アクセスできません')
        expect(URI.parse(current_url).path).to eq(root_path)
      end
    end

    context 'どこの運営会社にも紐づかないユーザーの場合' do
      let(:user) { create(:user, user_type: :personal) }

      before do
        login_user(user)
      end

      scenario 'ヘッダーに「運営管理」が表示されない' do
        visit root_path
        expect(page).not_to have_css('.navbar-inverse', text: '運営会社管理')
      end

      scenario 'URL直打ちでもアクセスできない' do
        visit corporation_manage_root_path
        expect(page).to have_css('.alert-warning', text: 'アクセスできません')
        expect(URI.parse(current_url).path).to eq(root_path)
      end
    end
  end
end
