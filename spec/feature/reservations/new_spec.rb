require 'rails_helper'

RSpec.feature 'Reservations::New', type: :feature do

  feature '直接URL叩かれた際の挙動' do
    context '施設のIDが渡されなかった場合 / 存在しないIDが渡された場合' do
      it "検索画面に遷移" do
      end
      it '検索条件を入力してください と表示' do
      end
    end
    context '施設IDが存在する場合' do
      it "検索条件が初期設定のものとなる" do
      end
    end
  end

  feature '検索条件を変更したときの挙動' do
    it '金額が再計算される' do
    end
  end

  feature '次へボタンを押したときの挙動' do
    context '全ての検索クエリが埋まっていない場合' do
      it '検索条件を適切に入力してください と表示' do
      end
      it '情報入力画面に戻る' do
      end
    end
    context '30分前より近い予約だった場合' do
      it 'ご予約はご利用の30分前までとなります と表示' do
      end
      it '情報入力画面に戻る' do
      end
    end
    context '日をまたぐ予約の場合' do
      it '日をまたいだ予約は出来ません と表示' do
      end
      it '情報入力画面に戻る' do
      end
    end
    context '既に予約が入ってしまった場合' do
      it 'ご指定の日時ではご利用頂けません と表示' do
      end
      it '情報入力画面に戻る' do
      end
    end
    context '店舗の運営時間外の予約の場合' do
      it 'ご予約時間が営業時間外となります と表示' do
      end
      it '情報入力画面に戻る' do
      end
    end
    context '条件が適切に入力された場合' do
      context 'クレカ払いの場合' do
        context '個人払いの場合' do
          context 'クレカ登録済の場合' do
            it '確認画面に遷移' do
            end
            it '入力した情報が引き継がれる' do
            end
          end
          context 'クレカ未登録の場合' do
            it 'クレカ登録画面に遷移' do
            end
          end
        end
        context '法人払いの場合' do
          context '所属会社がクレカ登録済の場合' do
            it '確認画面に遷移' do
            end
            it '入力した情報が引き継がれる' do
            end
          end
          context '所属会社がクレカ未登録' do
            it "「次へ」クリックでクレカ登録画面に遷移" do
            end
          end
        end
      end
      context '請求書払いの場合' do
        it '確認画面に遷移' do
        end
        it '入力した情報が引き継がれる' do
        end
      end
    end
  end

end
