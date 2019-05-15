class CorporationManage::FacilityDropinSubPlansController < CorporationManage::Base
  def index
    @facility = Facility.belongs_to_corporation(current_corporation).find(params[:facility_id])
    @facility_dropin_sub_plans = @facility.facility_dropin_sub_plans
  end
end
