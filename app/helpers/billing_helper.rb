module BillingHelper

  def credit_card_include?(params)
    params[:commit].present? ? params[:credit_card_include].present? : true
  end

  def invoice_include?(params)
    params[:commit].present? ? params[:invoice_include].present? : true
  end
  
  def display_usage_period(resource)
    resource.class.name == Reservation.name ? resource.decorate.usage_period_with_unit : t('common.drop_in')
  end
end


