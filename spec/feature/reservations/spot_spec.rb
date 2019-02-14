require 'rails_helper'

RSpec.feature 'Reservations::Spot', type: :feature do

  feature '初期表示' do
    it '上記から検索してくださいと表示' do
    end
    it 'Dataは空' do
    end
    it '時間は12:00' do
    end
    it 'Termは空' do
    end
    it 'Personは空' do
    end
  end

  feature 'Searchボタンを押したときの挙動' do
    context '全ての検索クエリが埋まっていない場合' do
      it '検索条件を適切に入力してくださいと表示' do
      end
      it '検索画面に戻る' do
      end
    end
    context '30分前より近い予約だった場合' do
      it 'ご予約はご利用の30分前までとなります と表示' do
      end
      it '検索画面に戻る' do
      end
    end
    context '日をまたぐ予約の場合' do
      it '日をまたいだ予約は出来ません と表示' do
      end
      it '検索画面に戻る' do
      end
    end
    context '条件が適切に入力された場合' do
      context '検索条件に合う施設がない場合' do
        it '該当する施設はございません と表示' do
        end
      end
      context '検索条件に合う施設がある場合' do
        it '該当する施設と予約ボタンが表示' do
        end
      end
    end
  end

  feature '予約するボタンを押したときの挙動' do
    context 'ログインしている場合' do
      it '情報入力画面に遷移' do
      end
      it '入力した情報が引き継がれる' do
      end
    end
    context 'ログインしていない場合' do
      it 'ログイン画面に遷移' do
      end
      it 'ログインに成功すると、情報入力画面に遷移' do
      end
      it 'ログイン後情報入力画面に情報が引き継がれる' do
      end
    end
  end
end
