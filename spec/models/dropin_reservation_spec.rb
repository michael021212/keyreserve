require 'rails_helper'

RSpec.describe DropinReservation, type: :model do

  describe 'scope' do
    describe 'in_range' do
    end

    describe 'confirmed_to_i' do
    end

    describe 'ready_to_send' do
    end
  end

  describe '.new_from_dropin_spot' do
  end

  #ここにカラム作成用のメソッドの判定とかも含める
  describe '.to_csv' do
  end

  describe '#method' do
    describe '#create_payment' do
      context 'ドロップイン利用したユーザが、クレカを登録していない場合' do
        it 'nilが返却される' do
        end
      end
      context 'クレカ登録済の場合' do
        it '支払い情報が作成される(色々細かくexample書く)' do
        end
      end
    end

    describe '#reservation_user' do
      context 'reservation_user_idがnilの場合' do
        it 'nilが返却される' do
        end
      end
      context 'reservation_user_idが登録されている場合' do
        it '予約に紐付いたユーザが返却される' do
        end
      end
    end

    describe '#send_dropin_reserved_mails' do
      it '予約者にメールが送られる' do
      end
      it '管理者に予約のメールが送られる' do
      end
      context '会議室予約とドロップイン予約を行ったユーザが異なる場合' do
        it '会議室の予約者にメールが送られる' do
        end
      end
    end

    describe '#send_cc_mail?' do
      context 'userとreservation_userが異なる場合' do
        it 'trueが返却される' do
        end
      end
      context 'userとreservation_userが同一の場合' do
        it 'falseが返却される' do
        end
      end
    end


  end
end

