require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe '.method' do
    describe '.convert_brand2kind(brand)' do
      context 'brandがVisaの場合' do
        it '1が返却される' do
        end
      end
      context 'brandがMasterCardの場合' do
        it '2が返却される' do
        end
      end
      context 'brandが上記以外の場合' do
        it 'nilが返却される' do
        end
      end
    end
  end

  describe '#method' do
    describe '#create_or_update_stripe_card' do
      context '処理中にエラーが発生した場合' do
        it 'エラーが発生する' do
        end
      end
      context '正常に処理が完了した場合' do
        it 'クレカの情報が色々情報書き換わる(後で詳しくitに書く)' do
        end
      end
    end

    describe '#create_stripe_card' do
    end

    describe '#update_stripe_card' do
    end

    describe '#full_card_no' do
      it 'XXXX XXXX XXXX の後に、4桁のカードナンバーが記載された文字列が返却される' do
      end
    end
  end

end
