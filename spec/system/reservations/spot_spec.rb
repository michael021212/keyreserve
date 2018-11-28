require 'rails_helper'

RSpec.feature 'Reservations::Spot', type: :system do

  feature '次のページへの遷移異常' do
    context '日付が空の場合' do
      scenario "元の画面に戻る" do
      end
    end
    context '時間が空の場合' do
      scenario "元の画面に戻る" do
      end
    end
    context '人数が空の場合' do
      scenario "元の画面に戻る" do
      end
    end
    context '予約開始時刻と終了時刻が一緒の場合' do
      scenario "元の画面に戻る" do
      end
    end
    context '予約時間が30分前を過ぎている場合' do
      scenario "「ご予約はご利用の30分前までとなります」と表示され、元の画面に戻る" do
      end
    end
  end

  feature '検索結果の表示' do
    context '検索条件に合う施設が空いていない場合' do
      scenario "該当する施設はございません。と表示される" do
      end
    end
    context '検索条件に合う施設が空いてる場合' do
      scenario "施設の予約ボタンが表示される" do
      end
    end
  end

  feature '次のページへの遷移' do
    scenario "予約ボタンを押すと、予約の作成ページへと遷移する" do
    end
  end
end

