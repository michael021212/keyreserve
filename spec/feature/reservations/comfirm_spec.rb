require 'rails_helper'

RSpec.feature 'Reservations::Comfirm', type: :feature do
  feature '正常な画面表示' do
    scenario "処理結果が正しく引き継がれている" do
    end
  end
  feature '異常な予約処理' do
    context '予約施設情報が引き継げなかった場合' do
      scenario "予約時に予期せぬエラーが発生しました。と表示され、施設検索画面に遷移" do
        # sessionの有り無しで判定してるっぽい
      end
    end
    context '予約が出来なかった場合' do
      scenario "予約時に予期せぬエラーが発生しました。と表示され、施設検索画面に遷移" do
      end
    end
  end
  feature '正常な予約処理' do
    scenario "管理者にメールが飛ぶ" do
    end
    scenario "予約者にメールが飛ぶ" do
    end
    context 'なんかの場合' do
      scenario "reseration_user_idにメールが飛ぶ" do
      end
    end
    scenario "予約完了ページへと遷移する" do
    end
  end
end


