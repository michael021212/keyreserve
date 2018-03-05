class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  layout 'users/layouts/register'

  def new
    @user = User.new
  end

  def create
    corporation ||= Corporation.find_by(token: params[:user][:corporation_token])
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.html do
          auto_login(@user)
          if corporation.present?
            if @user.corporation_users.create(corporation_id: corporation.id).valid?
              redirect_to corporations_dashboard_path, notice: "#{Corporation.model_name.human}を作成しました。"
            else
              redirect_to users_dashboard_path, notice: "#{User.model_name.human}を作成しました。"
            end
          else
            redirect_to users_dashboard_path, notice: "#{User.model_name.human}を作成しました。"
          end
        end
      end
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :name, :tel, :payway
    )
  end
end
