class Admin::CorporationsController < AdminController
  before_action :set_corporation, only: [:show, :edit, :update, :destroy]

  # GET /admin/corporations
  def index
    @corporations = Corporation.all.order(id: :desc).page(params[:page])
  end

  # GET /admin/corporations/new
  def new
    @corporation = Corporation.new
  end

  # GET /admin/corporations/1/edit
  def edit
  end

  # POST /admin/corporations
  def create
    @corporation = Corporation.new(corporation_params)

    if @corporation.save
      redirect_to [:admin, @corporation], notice: "#{Corporation.model_name.human}を作成しました。"
    else
      render :new
    end
  end

  def show
    @shops = @corporation.shops.order(id: :desc).page(params[:page])
  end

  # PATCH/PUT /admin/corporations/1
  def update
    if @corporation.update(corporation_params)
      redirect_to [:admin, @corporation], notice: "#{Corporation.model_name.human}を更新しました。"
    else
      render :edit
    end
  end

  # DELETE /admin/corporations/1
  def destroy
    @corporation.destroy
    redirect_to admin_corporations_path, notice: "#{Corporation.model_name.human}を削除しました。"
  end

  private

  def set_corporation
    @corporation = Corporation.find(params[:id])
  end

  def corporation_params
    params.require(:corporation).permit(
      :name, :kana, :tel, :fax, :postal_code, :address, :note, :ksc_token, :ks_corporation_id
    )
  end
end
