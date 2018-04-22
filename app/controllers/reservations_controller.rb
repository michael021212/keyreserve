class ReservationsController <  ApplicationController
  before_action :set_facility

  def events
    if @facility.reservations.present?
      @reservations = @facility.reservations
    end
  end

  private

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end
end
