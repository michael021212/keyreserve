class PersonalIdentificationsController < ApplicationController
  before_action :set_personal_identification, only: [:edit, :update]

  def new
    @personal_identification = current_user.build_personal_identification
  end

  def create
    @personal_identification = current_user.build_personal_identification
    @personal_identification = current_user.build_personal_identification(personal_identification_params)
    if @personal_identification.save
      redirect_to user_path, notice: "#{PersonalIdentification.model_name.human}書類のアップロードが完了しました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @personal_identification.update(personal_identification_params)
      redirect_to user_path, notice: "#{PersonalIdentification.model_name.human}書類のアップロードが完了しました。"
    else
      render :edit
    end
  end

  private

  def set_personal_identification
    @personal_identification = current_user.personal_identification
  end

  def personal_identification_params
    params.require(:personal_identification).permit(
      :front_img, :back_img, :card_type, :verified
    )
  end
end
