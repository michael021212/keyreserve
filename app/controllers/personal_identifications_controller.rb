class PersonalIdentificationsController < ApplicationController

  def create
    @personal_identification = current_user.build_personal_identification
    @personal_identification = current_user.build_personal_identification(personal_identification_params)
    if @personal_identification.save
      redirect_to user_path, notice: "#{PersonalIdentification.model_name.human}書類のアップロードが完了しました。"
    else
      render :new
    end
  end

  private

  def personal_identification_params
    params.require(:personal_identification).permit(
      {files: []}, :type
    )
  end
end
