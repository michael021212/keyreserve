require 'rails_helper'

RSpec.feature 'corporation_manage/user_contracts', type: :feature do
  let(:corporation) { create(:corporation) }
  let(:user) { create(:user) }
  let(:corporation_user) { create(:corporation_user,
                                  user: user,
                                  corporation: corporation) }

  feature '契約作成' do
    let(:target_user) { create(:user, name: 'ジョンレノン') }
    let(:shop) { create(:shop,
                        name: 'ジョン店',
                        corporation: corporation)}
    let(:plan) { create(:plan,
                        name: 'GODプラン',
                        corporation: corporation) }

    before do
      corporation_user
      shop
      target_user
      plan
      login_user(user)
    end

    scenario '契約を作成できる' do
      visit corporation_manage_root_path

      click_on('契約管理')

      within(find('.box-tools')) do
        click_on('新規追加')
      end

      select shop.name, from: 'user_contract[shop_id]'
      select target_user.name, from: 'user_contract[user_id]'
      select plan.name, from: 'user_contract[plan_id]'
      select '契約申し込み', from: 'user_contract[state]'
      select '2019', from: 'user_contract[started_on(1i)]'
      select '5月', from: 'user_contract[started_on(2i)]'
      select '25', from: 'user_contract[started_on(3i)]'
      select '2019', from: 'user_contract[finished_on(1i)]'
      select '10月', from: 'user_contract[finished_on(2i)]'
      select '25', from: 'user_contract[finished_on(3i)]'

      click_on('登録')

      expect(find('.alert-warning')).to have_content('契約を作成しました。')
      expect(find('.cy-user-name')).to have_content('ジョンレノン')
      expect(find('.cy-shop-name')).to have_content('ジョン店')
      expect(find('.cy-plan-name')).to have_content('GODプラン')
      expect(find('.cy-user-contract-state')).to have_content('契約申し込み')
      expect(find('.cy-user-contract-start-date')).to have_content('2019年05月25日')
      expect(find('.cy-user-contract-finish-date')).to have_content('2019年10月25日')
    end
  end

  feature '契約者編集' do
    let(:target_user) { create(:user, name: 'ジョンレノン') }
    let(:shop) { create(:shop,
                        name: 'ジョン店',
                        corporation: corporation)}
    let(:shop_2) { create(:shop,
                          name: 'トム店',
                          corporation: corporation)}
    let(:plan) { create(:plan,
                        name: 'GODプラン',
                        corporation: corporation) }
    let(:plan_2) { create(:plan,
                          name: 'HELLプラン',
                          corporation: corporation) }
    let(:user_contract) { create(:user_contract,
                                 user: target_user,
                                 corporation: corporation,
                                 shop: shop,
                                 plan: plan,
                                 state: :applying,
                                 started_on: Date.new(2019, 05, 25),
                                 finished_on: Date.new(2019, 10, 25))}

    before do
      corporation_user
      shop_2
      plan_2
      user_contract
      login_user(user)
    end

    scenario '契約を編集できる' do
      visit corporation_manage_root_path

      click_on('契約管理')

      within(find(".cy-user-contract-#{user_contract.id}")) do
        click_on('編集')
      end

      select shop_2.name, from: 'user_contract[shop_id]'
      select plan_2.name, from: 'user_contract[plan_id]'
      select '契約終了', from: 'user_contract[state]'
      select '2019', from: 'user_contract[started_on(1i)]'
      select '11月', from: 'user_contract[started_on(2i)]'
      select '20', from: 'user_contract[started_on(3i)]'
      select '2019', from: 'user_contract[finished_on(1i)]'
      select '12月', from: 'user_contract[finished_on(2i)]'
      select '25', from: 'user_contract[finished_on(3i)]'

      click_on('更新')

      expect(find('.alert-warning')).to have_content('契約を更新しました。')
      expect(find('.cy-user-name')).to have_content('ジョンレノン')
      expect(find('.cy-shop-name')).to have_content('トム店')
      expect(find('.cy-plan-name')).to have_content('HELLプラン')
      expect(find('.cy-user-contract-state')).to have_content('契約終了')
      expect(find('.cy-user-contract-start-date')).to have_content('2019年11月20日')
      expect(find('.cy-user-contract-finish-date')).to have_content('2019年12月25日')
    end
  end


  feature '契約削除' do
    let(:target_user) { create(:user, name: 'ジョンレノン') }
    let(:shop) { create(:shop, corporation: corporation)}
    let(:plan) { create(:plan, corporation: corporation) }
    let(:user_contract) { create(:user_contract,
                                 user: target_user,
                                 corporation: corporation,
                                 shop: shop,
                                 plan: plan) }

    before do
      corporation_user
      user_contract
      login_user(user)
    end

    scenario '契約を削除できる', js: true do
      visit corporation_manage_root_path

      click_on('契約管理')

      within(find(".cy-user-contract-#{user_contract.id}")) do
        click_on('削除')
      end

      page.driver.browser.switch_to.alert.accept

      expect(find('.alert-warning')).to have_content('契約を削除しました')
      expect(find('.table-striped')).not_to have_css(".cy-user-contract-#{user_contract.id}")
    end
  end
end
