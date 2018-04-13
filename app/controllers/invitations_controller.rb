class InvitationsController <  ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.parent_corporation_and_users(current_user).order(id: :desc).page(params[:page])
  end

  def show; end

  def new; end

  def create
    current_user.update(parent_token: Digest::MD5.hexdigest(current_user.email)) if current_user.parent_token.nil?
    if params[:email].present?
      NotificationMailer.user_invitation(params[:email], current_user).deliver_now
      redirect_to invitations_path, notice: 'ご招待メールを送りました'
    else
      flash[:alert] = 'メールアドレスを入力してください。'
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
