class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  layout 'users/layouts/register'

  def new
    @user = User.new
  end

  def create
    corporation ||= Corporation.find_by(token: params[:user][:corporation_token])
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user.corporation_users.create(corporation_id: corporation.id) if corporation.present?
        format.html do
          auto_login(@user)
          redirect_to corporations_dashboard_path
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
