require 'rails_helper'

RSpec.describe FacilityTemporaryPlanPrice, type: :model do

  describe '.select_plans_for_user_condition' do
    context 'userがnilの場合' do
      let(:user) { create(:user) }
      let(:plan) { create(:plan) }
      let(:user_contract) { create(:user_contract,
                                   user: user,
                                   plan: plan) }
      let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                             plan: plan) }
      let(:facility_temporary_plan_2) { create(:facility_temporary_plan,
                                             plan: nil) }

      before do
        user_contract
        facility_temporary_plan
        facility_temporary_plan_2
      end

      scenario 'facility_temporary_plan_2が返ってくる' do
        expect(FacilityTemporaryPlan.select_plans_for_user_condition(nil)).to eq([facility_temporary_plan_2])
      end
    end

    context 'userがいた場合' do
      let(:user) { create(:user) }
      let(:plan) { create(:plan) }
      let(:user_contract) { create(:user_contract,
                                   user: user,
                                   plan: plan) }
      let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                             plan: plan) }
      let(:facility_temporary_plan_2) { create(:facility_temporary_plan,
                                               plan: nil) }

      before do
        user_contract
        facility_temporary_plan
        facility_temporary_plan_2
      end

      scenario 'ユーザーが契約しているプランと関係のあるものだけが返ってくる' do
        expect(FacilityTemporaryPlan.select_plans_for_user_condition(user)).to eq([facility_temporary_plan])
      end
    end
  end
end
