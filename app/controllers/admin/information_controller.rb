class Admin::InformationController < AdminController
  before_action :set_information, only: [:show, :edit, :update, :destroy]

  def index
    @information = Information.order(id: :desc).page(params[:page])
  end

  def show; end

  def new
    @information = Information.new
  end

  def edit; end

  def create
    @information = Information.new(information_params)
    if @information.save
      flash[:notice] = "#{Information.model_name.human}を作成しました。"
      redirect_to admin_information_path(@information)
    else
      render :new
    end
  end

  def update
    if @information.update(information_params)
      flash[:notice] = "#{Information.model_name.human}を更新しました。"
      redirect_to admin_information_path(@information)
    else
      render :edit
    end
  end

  def destroy
    @information.destroy
    flash[:notice] = "#{Information.model_name.human}を削除しました。"
    redirect_to admin_information_index_path
  end

  private

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(
      :shop_id, :title, :description
    )
  end
end
