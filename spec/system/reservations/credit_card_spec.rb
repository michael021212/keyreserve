require 'rails_helper'

RSpec.feature 'Reservations::CreditCard', type: :system do
  feature 'カード登録画面' do
    context '入力異常がある場合' do
      scenario "エラーが発生して、クレカ登録画面に遷移" do
        # 全項目必須なので、それぞれ書く
      end
    end
    context '正常入力後、stripeとの通信がうまくいかない場合' do
      scenario "「クレジットカードの登録に失敗しました」と表示され、クレカ登録画面に遷移" do
      end
    end
    context '正常入力後、stripeとの通信がうまくいった場合' do
      scenario "確認画面に遷移" do
      end
    end
  end
end
