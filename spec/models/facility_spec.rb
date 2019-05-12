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

  describe '#min_houry_price' do
    let(:user) { create(:user) }
    let(:plan) { create(:plan) }
    let(:shop) { create(:shop) }
    let(:facility) { create(:facility, shop: shop) }
    let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                           plan: nil,
                                           facility: facility,
                                           standard_price_per_hour: 1000) }


    context 'ユーザーがどこのプランとも契約していなかった場合' do
      before do
        facility_temporary_plan
      end

      scenario '都度課金プランの金額がそのまま返ってくる' do
        expect(facility.min_hourly_price(user)).to eq(1000)
      end
    end

    context 'ユーザーがどこかのプランと契約していた場合' do
      let(:user_contract) { create(:user_contract,
                                   user: user,
                                   plan: plan) }

      before do
        user_contract
        facility_temporary_plan
      end

      scenario '都度課金プランの金額に50%の割引が適用された金額が返ってくる' do
        expect(facility.min_hourly_price(user)).to eq(500)
      end
    end
  end

  describe '#min_half_houry_price' do
    let(:user) { create(:user) }
    let(:plan) { create(:plan) }
    let(:shop) { create(:shop) }
    let(:facility) { create(:facility, shop: shop) }
    let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                           plan: nil,
                                           facility: facility,
                                           standard_price_per_hour: 1000) }


    context 'ユーザーがどこのプランとも契約していなかった場合' do
      before do
        facility_temporary_plan
      end

      scenario '都度課金プランの金額の30分分の金額が返ってくる' do
        expect(facility.min_half_hourly_price(user)).to eq(500)
      end
    end

    context 'ユーザーがどこかのプランと契約していた場合' do
      let(:user_contract) { create(:user_contract,
                                   user: user,
                                   plan: plan) }

      before do
        user_contract
        facility_temporary_plan
      end

      scenario '都度課金プランの金額の30分分の金額に50%の割引が適用された金額が返ってくる' do
        expect(facility.min_half_hourly_price(user)).to eq(250)
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
