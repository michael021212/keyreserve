require 'rails_helper'

RSpec.feature 'Reservations::New', type: :system do

  feature 'このページへの遷移異常' do
    context '施設のIDが渡されなかった場合' do
      scenario "エラー画面に遷移" do
      end
    end
    context 'プランに紐付かない施設IDが渡された場合' do
      scenario "エラー画面に遷移" do
      end
    end
  end

  feature '次のページへの遷移異常' do
    context '日付が空の場合' do
      scenario "予約作成画面に戻る" do
        #TODO: これ今できてないので直す
      end
    end
    context '時間が空の場合' do
      scenario "予約作成画面に戻る" do
        #TODO: これ今できてないので直す
      end
    end
    context '人数が空の場合' do
      scenario "予約作成画面に戻る" do
        #TODO: これ今できてないので直す
      end
    end
    context '予約時間が30分前を過ぎている場合' do
      scenario "「ご予約はご利用の30分前までとなります」と表示され、予約作成画面に戻る" do
      end
    end
  end

  feature '正常な画面表示' do
    scenario "検索条件が引き継がれている" do
    end
    scenario "料金が正しく計算されている" do
    end
    scenario "時間を変えると料金が再計算される" do
    end
    scenario "人数を変えると料金が再計算される" do
    end
    scenario "施設詳細が正しく表示されている" do
    end
  end

  feature '次のページへの正常遷移' do
    context 'クレカ支払いの場合' do
      context '個人払いの場合' do
        context 'クレカ登録済の場合' do
          scenario "「次へ」クリックで確認画面に遷移" do
          end
        end
        context 'クレカ未登録の場合' do
          scenario "「次へ」クリックでクレカ登録画面に遷移" do
          end
        end
      end
      context '法人払いの場合' do
        context '所属会社がクレカ未登録' do
          scenario "「次へ」クリックでクレカ登録画面に遷移" do
          end
        end
        context '所属会社がクレカ登録済' do
          scenario "確認画面に遷移" do
          end
        end
      end
    end
    context '請求書払いの場合' do
      scenario "「次へ」クリックで確認画面に遷移" do
      end
    end
  end
end

