module SessionHelper
  def login_user(user)
    visit sign_in_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button('ログイン')
  end
end
