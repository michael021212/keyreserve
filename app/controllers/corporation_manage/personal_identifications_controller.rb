class CorporationManage::PersonalIdentificationsController < CorporationManage::Base
  before_action :set_user
  before_action :set_personal_identification, only: %i[edit update]

  def new
    @personal_identification = @user.build_personal_identification
  end

  def create
    @personal_identification = @user.build_personal_identification(personal_identification_params)
    if @personal_identification.save
      redirect_to corporation_manage_user_path(@user), notice: "#{PersonalIdentification.model_name.human}を登録しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @personal_identification.update(personal_identification_params)
      redirect_to corporation_manage_user_path(@user), notice: "#{PersonalIdentification.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_corporation.users.find(params[:user_id])
  end

  def set_personal_identification
    @personal_identification = @user.personal_identification
  end

  def personal_identification_params
    params.require(:personal_identification).permit(
      :front_img,
      :back_img,
      :card_type,
      :status
    )
  end
end
