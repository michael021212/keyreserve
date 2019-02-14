require 'rails_helper'

RSpec.feature 'Reservations::CreditCard', type: :feature do
  feature '登録ボタンを押した際の挙動' do
    context '入力不備がある場合' do
      it "バリデーションエラーが発生" do
      end
      it 'クレカ情報入力画面に遷移' do
      end
    end
    context 'stripeに登録拒否された場合' do
      it "クレジットカードの登録に失敗しました。入力情報が正しいか、今一度ご確認ください。と表示" do
      end
      it 'クレカ情報入力画面に遷移' do
      end
    end
    context 'stripeに登録出来た場合' do
      it "確認画面に遷移" do
      end
    end
  end
end

