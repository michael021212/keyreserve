class UsersController < Users::ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  layout 'users/layouts/register'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html do
          auto_login(@user)
          redirect_to users_path
        end
      else
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :payway
    )
  end
end
