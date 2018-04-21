class InvitationsController <  ApplicationController

  def index
    @users = current_user_corp.users.page(params[:page])
  end

  def new; end

  def create
    current_user_corp.update(parent_token: Digest::MD5.hexdigest(current_user_corp.email))  if current_user_corp.parent_token.nil?
    if params[:email].present?
      NotificationMailer.user_invitation(params[:email], current_user_corp).deliver_now
      redirect_to invitations_path, notice: 'ご招待メールを送信しました'
    else
      flash[:alert] = 'メールアドレスを入力してください。'
      render :new
    end
  end

end
