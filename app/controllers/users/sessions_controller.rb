class Users::SessionsController < ApplicationController
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

  def post_reminder
    if User.find_by(email: params[:email]).present?
      @user = User.find_by(email: params[:email])
      @user.deliver_reset_password_instructions! if @user.present?
    else
      flash[:alert] = 'メールアドレスが入力されていないか、メールアドレスが登録されていません。'
      render :reminder
    end
  end

  def reset_password
    @user = User.load_from_reset_password_token(params[:token])
    return render :reset_password_error if @user.blank?
  end

  def update_password
    @user = User.load_from_reset_password_token(params[:token])
    if @user.blank?
      not_authenticated
      return
    end
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      @user.generate_reset_password_token!
      auto_login(@user)
      if current_corporation.present?
        redirect_to corporations_dashboard_path, notice: 'パスワードの再設定が完了しました。'
      else
        redirect_to users_dashboard_path, notice: 'パスワードの再設定が完了しました。'
      end
    else
      render :reset_password
    end
  end
end
