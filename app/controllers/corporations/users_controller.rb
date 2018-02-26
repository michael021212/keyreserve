class Corporations::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = current_corporation.users.order(id: :desc).page(params[:page])
  end

  def show; end

  def new; end

  def create
    current_corporation.update(token: Digest::MD5.hexdigest(current_corporation.id.to_s)) if current_corporation.token.nil?
    if params[:email].present?
      Users::NotificationMailer.user_invitation(params[:email], current_corporation).deliver_now
      redirect_to new_corporations_user_path, notice: 'ユーザ招待メールを送りました'
    else
      flash[:alert] = 'メールアドレスを入力してください。'
      render :new
    end
  end

  private

  def set_user
    @user = current_corporation.users.find(params[:id])
  end
end
