class InformationController <  ApplicationController
  before_action :set_recent_information
  before_action :set_information, only: [:show]

  def index
    @information = Information.enable_disp.order(publish_time: :desc).page(params[:page])
  end

  def show
  end

  private

  def set_recent_information
    @recent_information = Information.enable_disp.order(publish_time: :desc).limit(5)
  end

  def set_information
    @information = Information.find(params[:id])
  end
end
