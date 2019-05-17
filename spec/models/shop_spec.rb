require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '#do_not_over_closing_time' do
    context '開店時刻が閉店時間を超えていなかった場合' do
      let(:shop) { build(:shop,
                         opening_time: '12:00:00',
                         closing_time: '18:00:00')}

      it 'バリデーションチェックが通る' do
        expect(shop.valid?).to eq(true)
      end
    end

    context '開店時刻が閉店時間を超えていた場合' do
      let(:shop) { build(:shop,
                         opening_time: '18:00:00',
                         closing_time: '16:00:00')}

      it 'バリデーションチェックが通らない' do
        expect(shop.valid?).to eq(false)
        expect(shop.errors[:opening_time].first).to eq('開店時間は閉店時間より早めにしてください')
      end
    end
  end
end
