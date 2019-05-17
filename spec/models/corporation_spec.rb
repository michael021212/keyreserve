require 'rails_helper'

RSpec.describe Corporation, type: :model do
  describe '.methods' do
    describe '.sync_from_api' do
      context 'API通信に失敗した時' do
        it '◯◯を返す' do
        end
      end
      context 'API通信に成功した時' do
        context '0件の法人が登録されている場合' do
          it '空の配列が返却される' do
          end
        end
        context '1件の法人が登録されている場合' do
          it '企業のid、nameの配列が返却される' do
          end
        end
        context '2件の法人が登録されている場合' do
          it '企業のid、nameの配列が2件、連想配列の形式で返却される' do
          end
        end
      end
    end
  end

  describe '#method' do
    describe '#selectable_keys' do
      context '選択可能な鍵が一本もない場合' do
        it '空の配列が返却される' do
        end
      end
      context '選択可能な鍵が1本ある場合' do
        it 'nameとkey_idの配列が1件返却される' do
        end
      end
      context '選択可能な鍵が2本ある場合' do
        it 'nameとkey_idの配列が2件、連想配列の形で返却される' do
        end
      end
    end
  end

  describe '#plans_linked_with_user?' do
    context 'ユーザーが対象の運営会社が所持するプランと契約していた場合' do
      let(:corporation)   { create(:corporation) }
      let(:user)          { create(:user) }
      let(:plan)          { create(:plan, corporation: corporation)}
      let(:user_contract) { create(:user_contract,
                                   plan: plan,
                                   user: user)}

      before do
        user_contract
      end

      scenario 'trueが返る' do
        expect(corporation.plans_linked_with_user?(user)).to eq(true)
      end
    end

    context 'ユーザーが対象の運営会社が所持するプランと契約していなかった場合' do
      let(:corporation)         { create(:corporation) }
      let(:another_corporation) { create(:corporation) }
      let(:user)                { create(:user) }
      let(:plan)                { create(:plan, corporation: corporation) }
      let(:plan_2)              { create(:plan, corporation: another_corporation) }
      let(:user_contract)       { create(:user_contract,
                                         plan: plan_2,
                                         user: user)}

      before do
        user_contract
      end

      scenario 'falseが返る' do
        expect(corporation.plans_linked_with_user?(user)).to eq(false)
      end
    end
  end
end
