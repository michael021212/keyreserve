class CorporationManage::InformationController < CorporationManage::Base
  before_action :set_information, only: %i[show edit update destroy]

  def index
    @information_lists = Information.target_shops(current_corporation.shops.ids)
                                    .order(id: :desc)
                                    .page(params[:page])
  end

  def show; end

  def new
    @information = Information.new
  end

  def edit; end

  def create
    @information = Information.new(information_params)
    if @information.save
      redirect_to corporation_manage_information_path(@information), notice: t('common.messages.created', name: Information.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @information.update(information_params)
      redirect_to corporation_manage_information_path(@information), notice: t('common.messages.updated', name: Information.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @information.destroy!
    redirect_to corporation_manage_information_index_path, notice: t('common.messages.deleted', name: Information.model_name.human)
  end

  private

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(
      :shop_id,
      :title,
      :description,
      :publish_time,
      :mail_send_flag,
      :info_type,
      :info_target_type,
      shop_ids: []
    ).merge(info_target_type: :shop_users)
  end
end
