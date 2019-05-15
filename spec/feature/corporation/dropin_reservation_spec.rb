require 'rails_helper'

RSpec.feature 'corporation/dropin_reservations', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }
  let(:shop) { create(:shop, corporation: corporation) }
  
  feature 'ドロップイン詳細' do
    let(:facility) { create(:facility,
                            shop: shop,
                            name: 'ぺご施設')}
    let(:billing) { create(:billing,
                           shop: shop,
                           user: user,
                           price: 1000,
                           year: 2019,
                           month: 10) }
    let(:payment) { create(:payment,
                           user: user,
                           corporation: corporation,
                           facility: facility)}
    let(:dropin_reservation) { create(:dropin_reservation,
                                      facility: facility,
                                      user: user,
                                      payment: payment,
                                      checkin: Time.zone.local(2019, 10, 20, 10, 00),
                                      checkout: Time.zone.local(2019, 10, 20, 18, 00),
                                      state: :confirmed,
                                      price: 10000,
                                      mail_send_flag: true,
                                      billing: billing) }
    
    before do
      dropin_reservation
      corporation_user
      login_user(user)
    end
    
    scenario 'ドロップイン詳細が表示される' do
      visit corporation_manage_dropin_reservations_path
      
      within(".cy-dropin-reservation-#{dropin_reservation.id}") do
        click_on('詳細')
      end

      expect(page).to have_css('.cy-dropin-reservation-checkin', text: '2019年10月20日(日) 10:00')
      expect(page).to have_css('.cy-dropin-reservation-checkout', text: '2019年10月20日(日) 18:00')
      expect(page).to have_css('.cy-dropin-reservation-price', text: '10,000 円')
      expect(page).to have_css('.cy-dropin-reservation-mail-send', text: '◯')
    end
  end
end
