class FacilitiesController <  ApplicationController

  def index
  end

  def edit
  end

  def update
    if @facility.update(facility_params)
      redirect_to facility_path, notice: 'アカウント情報を更新しました'
    else
      render :edit
    end
  end

  def show
  end

  private

  def set_facility
    @facility = current_facility
  end

  def set_ks_facility
    @ks_facilitys = Facility.sync_from_api
  end

  def facility_params
    params.require(:facility).permit(
      :name, :kana, :tel, :postal_code, :address, :note
    )
  end
end
