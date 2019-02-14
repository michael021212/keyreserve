require 'rails_helper'

RSpec.feature 'Reservations::Comfirm', type: :feature do

  feature 'URL直叩きされた際の挙動' do
    it '検索画面に遷移' do
    end
  end

  feature '予約するボタンを押した際の挙動' do
    context '予約が出来なかった場合' do
      it "予約時に予期せぬエラーが発生しました。と表示" do
      end
      it '検索画面に遷移' do
      end
    end

    context '正常に予約できた場合' do
      it '予約レコードが正常に作成' do
      end
      it "管理者にメールが飛ぶ" do
      end
      it "予約者にメールが飛ぶ" do
      end
      context 'cend_cc_mailの場合' do
        it "reseration_user_idにメールが飛ぶ" do
        end
      end
      it "予約完了ページへと遷移" do
      end
    end
  end
end
