class CorporationsController <  ApplicationController
  before_action :set_corporation, :set_ks_corporation

  def edit
  end

  def update
    if @corporation.update(corporation_params)
      redirect_to corporation_path, notice: 'アカウント情報を更新しました'
    else
      render :edit
    end
  end

  def show
  end

  private

  def set_corporation
    current_user
    @corporation = current_corporation
  end

  def set_ks_corporation
    @ks_corporations = Corporation.sync_from_api
  end

  def corporation_params
    params.require(:corporation).permit(
      :name, :kana, :tel, :postal_code, :address, :note
    )
  end
end
