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
      visit corporation_manage_root_path

      click_on('プラン管理')

      within(find('.box-tools')) do
        click_on('新規追加')
      end

      find('#plan_default_flag').click
      fill_in 'plan[name]', with: 'GODプラン'
      fill_in 'plan[price]', with: '100000'
      fill_in 'plan[description]', with: 'GODになれるプランだよ'

      click_on('登録')

      expect(find('.alert-warning')).to have_content('プランを作成しました。')
      expect(find('.cy-plan-flag')).to have_content('◯')
      expect(find('.cy-plan-name')).to have_content('GODプラン')
      expect(find('.cy-plan-price')).to have_content('月額 100,000 円')
      expect(find('.cy-plan-description')).to have_content('GODになれるプランだよ')
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
      visit corporation_manage_root_path

      click_on('プラン管理')

      within(find(".cy-plan-#{plan.id}")) do
        click_on('編集')
      end

      find('#plan_default_flag').click
      fill_in 'plan[name]', with: 'HELLプラン'
      fill_in 'plan[price]', with: '500000'
      fill_in 'plan[description]', with: '特に何もないプランだよ'

      click_on('更新')

      expect(find('.alert-warning')).to have_content('プランを更新しました。')
      expect(find('.cy-plan-flag')).not_to have_content('◯')
      expect(find('.cy-plan-name')).to have_content('HELLプラン')
      expect(find('.cy-plan-price')).to have_content('月額 500,000 円')
      expect(find('.cy-plan-description')).to have_content('特に何もないプランだよ')
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

      within(find(".cy-plan-#{plan.id}")) do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(find('.alert-warning')).to have_content('プランを削除しました。')
      expect(find('.table-striped')).not_to have_css(".cy-plan-#{plan.id}")
    end
  end
end
