require 'rails_helper'

RSpec.feature 'corporation/plans', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature 'プラン作成' do
    before do
      corporation_user
      login_user(user)
    end

    scenario 'プランを作成できる' do
      plan_attributes = build(:plan)
      
      visit corporation_manage_root_path

      click_on('プラン管理')

      within('.box-tools') do
        click_on('新規追加')
      end

      find('#plan_default_flag').click
      fill_in 'プラン名', with: plan_attributes.name
      fill_in '月額', with: plan_attributes.price
      fill_in '説明', with: plan_attributes.description

      click_on('登録')

      expect(page).to have_css('.alert-warning')
      expect(page).to have_css('.cy-plan-name', text: plan_attributes.name)
      expect(page).to have_css('.cy-plan-price', text: plan_attributes.price)
      expect(page).to have_css('.cy-plan-description', text: plan_attributes.description)
    end
  end

  feature 'プラン編集' do
    let(:plan) { create(:plan,
                        corporation: corporation,
                        default_flag: true,
                        name: 'GODプラン',
                        price: '100000',
                        description: 'GODになれるプランだよ') }

    before do
      corporation_user
      plan
      login_user(user)
    end

    scenario 'プランを編集できる' do
      plan_attributes = build(:plan)
      
      visit corporation_manage_root_path

      click_on('プラン管理')

      within(".cy-plan-#{plan.id}") do
        click_on('編集')
      end

      find('#plan_default_flag').click
      fill_in 'プラン名', with: plan_attributes.name
      fill_in '月額', with: plan_attributes.price
      fill_in '説明', with: plan_attributes.description

      click_on('更新')

      expect(page).to have_css('.alert-warning')
      expect(page).to have_css('.cy-plan-name', text: plan_attributes.name)
      expect(page).to have_css('.cy-plan-price', text: plan_attributes.price)
      expect(page).to have_css('.cy-plan-description', text: plan_attributes.description)
    end
  end

  feature 'プラン削除' do
    let(:plan) { create(:plan, corporation: corporation) }

    before do
      corporation_user
      plan
      login_user(user)
    end

    scenario 'プランを削除できる', js: true do
      visit corporation_manage_root_path

      click_on('プラン管理')

      within(".cy-plan-#{plan.id}") do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css('.alert-warning')
      expect(page).not_to have_css(".cy-plan-#{plan.id}")
    end
  end
end
