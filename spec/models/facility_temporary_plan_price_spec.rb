require 'rails_helper'

RSpec.describe FacilityTemporaryPlanPrice, type: :model do

  describe '.squeeze_from_plans_and_time' do
    let(:facility_temporary_plan)         { create(:facility_temporary_plan) }
    let(:facility_temporary_plan_2)       { create(:facility_temporary_plan) }
    let(:facility_temporary_plan_price)   { create(:facility_temporary_plan_price,
                                                   facility_temporary_plan: facility_temporary_plan,
                                                   starting_time: Time.zone.local(2019, 10, 15, 9, 00),
                                                   ending_time: Time.zone.local(2019, 10, 15, 17, 00),
                                                   price: 0) }
    let(:facility_temporary_plan_price_2) { create(:facility_temporary_plan_price,
                                                   facility_temporary_plan: facility_temporary_plan,
                                                   starting_time: Time.zone.local(2019, 10, 12, 15, 00),
                                                   ending_time: Time.zone.local(2019, 10, 16, 20, 00),
                                                   price: 1000) }
    let(:facility_temporary_plan_price_3) { create(:facility_temporary_plan_price,
                                                   facility_temporary_plan: facility_temporary_plan_2,
                                                   starting_time: Time.zone.local(2019, 10, 12, 15, 00),
                                                   ending_time: Time.zone.local(2019, 10, 16, 20, 00),
                                                   price: 0) }

    before do
      facility_temporary_plan
      facility_temporary_plan_2
      facility_temporary_plan_price
      facility_temporary_plan_price_2
      facility_temporary_plan_price_3
    end

    scenario 'facility_temporary_plan_price_2が返ってくる' do
      target_plans = [facility_temporary_plan, facility_temporary_plan_2]
      expect(FacilityTemporaryPlanPrice.squeeze_from_plans_and_time(target_plans, Time.zone.local(2019, 10, 10, 16, 00)))
             .to eq([facility_temporary_plan_price_2])
    end
  end
end
