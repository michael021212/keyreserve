module BillingHelper

  def credit_card_include?(params)
    params[:commit].present? ? params[:credit_card_include].present? : true
  end

  def invoice_include?(params)
    params[:commit].present? ? params[:invoice_include].present? : true
  end
end


