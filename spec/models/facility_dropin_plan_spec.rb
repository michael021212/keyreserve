require 'rails_helper'

RSpec.describe FacilityDropinPlan, type: :model do

  describe '#method' do
    describe '#plan_name' do
      context '紐づくプランがない場合' do
        it '「非会員」が返却される' do
        end
      end
      context '紐づくプランがある場合' do
        it 'プラン名が返却される' do
        end
      end
    end
  end
end
