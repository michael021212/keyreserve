class Admin::PersonalIdentificationsController < AdminController
  before_action :set_user
  before_action :set_personal_identification

  def new
    @personal_identification = @user.build_personal_identification
  end

  def edit; end

  def create
    @personal_identification = @user.build_personal_identification(personal_identification_params)
    if @personal_identification.save
      redirect_to [:admin, @user], notice: "#{PersonalIdentification.model_name.human}を登録しました。"
    else
      render :new
    end
  end

  def update
    if @personal_identification.update(personal_identification_params)
      redirect_to [:admin, @user], notice: "#{PersonalIdentification.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_personal_identification
    @personal_identification = @user.personal_identification
  end

  def personal_identification_params
    params.require(:personal_identification).permit(
      :front_img, :back_img, :card_type, :status
    )
  end
end
