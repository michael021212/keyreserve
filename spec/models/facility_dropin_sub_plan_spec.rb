require 'rails_helper'

RSpec.describe FacilityDropinSubPlan, type: :model do

  describe 'scope' do
    describe 'in_range' do
    end

    describe 'belongs_to_facility' do
    end
  end

  describe 'custom_validation' do
    describe 'within_business_hours' do
      context '開始時間と終了時間が同じな場合' do
      end
      context '開始時間と終了時間を超えてしまっている場合' do
      end
      context '開始時刻が営業時間外の場合' do
      end
      context '終了時刻が営業時間外の場合' do
      end
    end
  end

  describe '#method' do
    describe '#with_plan_name' do
    end

    describe '#using_period' do
    end

    describe '#using_hours' do
    end

    describe '#assign_facility_key' do
    end

  end

  describe '.method' do
    describe '.selections_with_plan_name' do
    end

    describe '.available_ids' do
    end
  end
end
