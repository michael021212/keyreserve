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
    let(:user) { create(:user,
                        name: '西尾') }

    context '運営会社に紐づくユーザーが存在する場合' do
      let(:corporation_user) { create(:corporation_user,
                                      user: user,
                                      corporation: corporation) }

      before do
        corporation
        user
        corporation_user
        login_user(user)
      end

      scenario '運営会社のダッシュボードにアクセスできる' do
        visit root_path
        within(find('.navbar-inverse')) do
          click_on('施設管理')
        end
        expect(find('.logo-lg')).to have_content('西尾会社')
        within(find('.cy-corpoartion-table')) do
          expect(find('.cy-corporation-name')).to have_content('西尾会社')
          expect(find('.cy-corporation-kana')).to have_content('サイオカイシャ')
          expect(find('.cy-corporation-tel')).to have_content('08012331233')
          expect(find('.cy-corporation-postal-code')).to have_content('133-1231')
          expect(find('.cy-corporation-address')).to have_content('東京都 渋谷区 宇田川1-1-19')
          expect(find('.cy-corporation-note')).to have_content('アップルを超える会社なんだぜ。')
        end
      end
    end

    context 'どこの運営会社にも紐づかないユーザーの場合' do
      before do
        corporation
        user
        login_user(user)
      end

      scenario 'ヘッダーに「施設管理」が表示されない' do
        visit root_path
        expect(find('.navbar-inverse')).not_to have_content('施設管理')
      end

      scenario 'URL直打ちでもアクセスできない' do
        visit corporation_manage_root_path
        expect(find('.alert-warning')).to have_content('アクセスできません')
        expect(URI.parse(current_url).path).to eq(root_path)
      end
    end
  end
end
