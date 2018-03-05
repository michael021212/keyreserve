class CorporationsController <  ApplicationController
  before_action :set_corporation, :set_ks_corporation

  def edit
    @ks_corporations = Corporation.sync_from_api
  end

  def update
    if @corporation.update(corporation_params)
      redirect_to corporation_path, notice: 'アカウント情報を更新しました'
    else
      render :edit
    end
  end

  def show
    # KS法人の名前を取得する
    if current_corporation.try(:ks_corporation_id)
      @ks_corporation = @ks_corporations.select{ |c| c[1] == current_corporation.ks_corporation_id.to_i }
      @ks_corporation_name = @ks_corporation.flatten[0]
    end
  end

  private

  def set_corporation
    @corporation = current_corporation
  end

  def set_ks_corporation
    @ks_corporations = Corporation.sync_from_api
  end

  def corporation_params
    params.require(:corporation).permit(
      :name, :kana, :tel, :postal_code, :address, :note, :token, :ks_corporation_id
    )
  end
end
