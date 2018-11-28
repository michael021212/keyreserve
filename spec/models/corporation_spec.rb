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

end
