class Users::SessionsController < Users::ApplicationController
  layout 'users/layouts/sign_in'
  skip_before_action :require_login

  def new; end

  def create
    if login(params[:email], params[:password])
      redirect_to root_path
    else
      flash[:danger] = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    logout
    redirect_to users_sign_in_path, notice: 'ログアウトしました。'
  end
end
