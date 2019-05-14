require 'rails_helper'

RSpec.feature 'corporation_manage/resevations', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }
  let(:shop) { create(:shop, corporation: corporation) }
  let(:facility) { create(:facility,
                          shop: shop,
                          name: '西尾施設') }

  feature '予約の作成' do
    context '予約ブロックを作成しようとした場合' do
      before do
        facility
        corporation_user
        login_user(user)
      end

      scenario '予約ブロックを作成できる', js: true do
        visit corporation_manage_root_path

        click_on('予約管理')
        sleep 0.2
        click_on('施設予約')
        click_on('新規追加')

        find('#reservation_block_flag').click
        select '西尾施設', from: '施設'
        select_datetime('reservation', 'checkin', Time.zone.local(2019, 10, 15, 12, 30))
        select '2.5時間', from: '利用時間'

        click_on('登録')

        expect(page).to have_css('.alert-warning', text: '予約ブロックを作成しました。')
        expect(page).to have_css('.cy-reservation-block-flag', text: '◯')
        expect(page).to have_css('.cy-reservation-checkin', text: '2019/10/15 12:30')
        expect(page).to have_css('.cy-reservation-usage-period', text: '2.5時間')
      end
    end

    context '普通の予約を作成しようとした場合' do
      let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                             facility: facility,
                                             plan_id: nil,
                                             standard_price_per_hour: 1000) }
      let(:user_corp) { create(:user_corp) }
      let(:target_user) { create(:user,
                                 name: '橋本環奈',
                                 payway: :creditcard,
                                 parent_id: user_corp.id) }
      let(:credit_card) { create(:credit_card, user: target_user) }
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation) }

      before do
        facility_temporary_plan
        credit_card
        corporation_user
        corporation_user_2
        login_user(user)
      end

      scenario '予約を作成できる', js: true do
        allow_any_instance_of(Payment).to receive(:stripe_charge!)
        reservation_attributes = build(:reservation,
                                       facility: facility,
                                       user: target_user,
                                       num: 5)

        visit corporation_manage_root_path

        click_on('予約管理')
        sleep 0.2
        click_on('施設予約')
        click_on('新規追加')

        select reservation_attributes.user_name, from: '利用者名'
        fill_in '利用人数', with: reservation_attributes.num
        select_datetime('reservation', 'checkin', Time.zone.local(2019, 10, 15, 12, 30))
        select '2.5時間', from: '利用時間'

        click_on('登録')
        click_on('決済する')

        expect(page).to have_css('.alert-warning', text: '施設予約を作成しました。')
        expect(page).to have_css('.cy-reservation-block-flag', text: '-')
        expect(page).to have_css('.cy-reservation-checkin', text: '2019/10/15 12:30')
        expect(page).to have_css('.cy-reservation-usage-period', text: '2.5時間')
        expect(page).to have_css('.cy-reservation-price', text: '2,500 円')
        expect(ActionMailer::Base.deliveries.size).to eq(3)
      end
    end

    context 'クレジットカードを持っていないユーザーを選択した場合' do
      let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                             facility: facility,
                                             plan_id: nil,
                                             standard_price_per_hour: 1000) }
      let(:target_user) { create(:user,
                                 name: '橋本環奈',
                                 payway: :creditcard) }
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation) }

      before do
        facility_temporary_plan
        corporation_user
        corporation_user_2
        login_user(user)
      end

      scenario 'バリデーションエラーで弾かれる', js: true do
        reservation_attributes = build(:reservation,
                                       facility: facility,
                                       user: target_user,
                                       num: 5)

        visit corporation_manage_root_path

        click_on('予約管理')
        sleep 0.2
        click_on('施設予約')
        click_on('新規追加')

        select reservation_attributes.user_name, from: '利用者名'
        fill_in '利用人数', with: reservation_attributes.num
        select_datetime('reservation', 'checkin', Time.zone.local(2019, 10, 15, 12, 30))
        select '2.5時間', from: '利用時間'

        click_on('登録')

        expect(page).to have_content('指定したユーザーはまだクレジットカードを登録していません')
      end
    end

    context '指定した時間内にすでに予約が存在した場合' do
      let(:facility_temporary_plan) { create(:facility_temporary_plan,
                                             facility: facility,
                                             plan_id: nil,
                                             standard_price_per_hour: 1000) }
      let(:target_user) { create(:user,
                                 name: '橋本環奈',
                                 payway: :creditcard) }
      let(:corporation_user_2) { create(:corporation_user,
                                        user: target_user,
                                        corporation: corporation) }
      let(:reservation) { create(:reservation,
                                 user: user,
                                 facility: facility,
                                 checkin: Time.zone.local(2019, 10, 15, 11, 30),
                                 checkout: Time.zone.local(2019, 10, 15, 12, 30)) }

      before do
        reservation
        facility_temporary_plan
        corporation_user
        corporation_user_2
        login_user(user)
      end

      scenario 'バリデーションエラーで弾かれる', js: true do
        reservation_attributes = build(:reservation,
                                       facility: facility,
                                       user: target_user,
                                       num: 5)

        visit corporation_manage_root_path

        click_on('予約管理')
        sleep 0.2
        click_on('施設予約')
        click_on('新規追加')

        select reservation_attributes.user_name, from: '利用者名'
        fill_in '利用人数', with: reservation_attributes.num
        select_datetime('reservation', 'checkin', Time.zone.local(2019, 10, 15, 11, 30))
        select '2.5時間', from: '利用時間'

        click_on('登録')

        expect(page).to have_content('その時間帯にはすでに予約が存在しています')
      end
    end
  end
end
