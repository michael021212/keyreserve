require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#contract_plan_ids' do
    context 'ユーザーが複数のプランと契約していた場合' do
      let(:user)            { create(:user) }
      let(:plan)            { create(:plan) }
      let(:plan_2)          { create(:plan) }
      let(:user_contract)   { create(:user_contract,
                                     user: user,
                                     plan: plan) }
      let(:user_contract_2) { create(:user_contract,
                                     user: user,
                                     plan: plan_2) }

      before do
        user_contract
        user_contract_2
      end

      scenario 'プランIDの配列を取得できる' do
        expect(user.contract_plan_ids).to eq([plan.id, plan_2.id])
      end
    end

    context 'ユーザーがどことも契約をしていなかった場合' do
      let(:user) { create(:user) }

      scenario '空の配列が返ってくる' do
        expect(user.contract_plan_ids).to eq([])
      end
    end
  end
end
