class CreditCardsController <  ApplicationController
  before_action :set_credit_card, only: [:edit, :update, :show]

  def new
    @credit_card = current_user.build_credit_card
  end

  def create
    @credit_card = current_user.build_credit_card(credit_card_params)
    @credit_card.prepare_stripe_card
    return(render :new) unless @credit_card.valid?
    @credit_card.save!
    current_user.activated!
    if session[:shop_id].present? && session[:plan_id].present?
      redirect_to shop_plan_user_contracts_credit_card_path(Shop.find(session[:shop_id]), Plan.find(session[:plan_id])), notice: 'クレジットカードを登録しました。'
    else
      redirect_to credit_card_path, notice: 'クレジットカードを登録しました。'
    end
  rescue => e
    logger.warn("#{e.class.name} #{e.message}")
    flash[:alert] = 'クレジットカードの登録に失敗しました'
    render :new
  end

  def edit; end

  def update
    @credit_card.assign_attributes(credit_card_params)
    @credit_card.prepare_stripe_card
    return(render :edit) unless @credit_card.valid?
    @credit_card.save!
    redirect_to credit_card_path, notice: 'クレジットカードを更新しました。'
  rescue
    flash[:alert] = 'クレジットカードの登録に失敗しました'
    render :edit
  end

  def show; end

  private

  def set_credit_card
    @credit_card = current_user.credit_card
  end

  def credit_card_params
    params.require(:credit_card).permit(
      :number, :exp, :holder_name, :cvc
    )
  end
end
