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
      redirect_to corporation_manage_information_path(@information), notice: "#{Information.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def update
    if @information.update(information_params)
      redirect_to corporation_manage_information_path(@information), notice: "#{Information.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @information.destroy!
    redirect_to corporation_manage_information_index_path, notice: "#{Information.model_name.human}を削除しました。"
  end

  private

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(
      :shop_id, :title, :description, :publish_time, :mail_send_flag, :info_type, :info_target_type,
      shop_ids: []
    )
  end
end
