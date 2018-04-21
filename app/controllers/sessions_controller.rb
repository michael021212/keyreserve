class SessionsController < ApplicationController
  def new; end

  def create
    if login(params[:email], params[:password])
      if session[:parent_token].present?
        user_corp ||= UserCorp.find_by(parent_token: session[:parent_token])
        current_user.update(parent_id: user_corp.id) if user_corp.present?
        session[:parent_token] = nil
      end
      redirect_to root_path
    else
      flash[:danger] = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  def post_reminder
    if User.find_by(email: params[:email]).present?
      @user = User.find_by(email: params[:email])
      @user.deliver_reset_password_instructions! if @user.present?
    else
      flash[:danger] = 'メールアドレスが入力されていないか、メールアドレスが登録されていません。'
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
      render :reset_password
    end
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      @user.generate_reset_password_token!
      auto_login(@user)
      redirect_to root_path, notice: 'パスワードの再設定が完了しました。'
    else
      render :reset_password
    end
  end
end
