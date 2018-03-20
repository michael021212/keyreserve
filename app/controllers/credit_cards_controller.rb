class CreditCardsController <  ApplicationController
  before_action :set_credit_card, only: [:edit, :update, :show]

  def new
    @credit_card = current_user.build_credit_card
  end

  def create
    @credit_card = current_user.build_credit_card(credit_card_params)
    return(render :new) unless @credit_card.valid?
    begin
      @credit_card.save!
      current_user.activated!
      redirect_to credit_card_path, notice: 'クレジットカードを登録しました。'
    rescue => e
      logger.warn("#{e.class.name} #{e.message}")
      flash[:alert] = 'クレジットカードの登録に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    @credit_card.assign_attributes(credit_card_params)
    return(render :edit) unless @credit_card.valid?
    begin
      @credit_card.update!(credit_card_params)
      redirect_to credit_card_path, notice: 'クレジットカードを更新しました。'
    rescue
      @credit_card.sent_stripe_request = false
      flash[:alert] = 'クレジットカードの登録に失敗しました'
      render :edit
    end
  end

  def show; end

  private

  def set_credit_card
    @credit_card = current_user.credit_card
  end

  def credit_card_params
    params.require(:credit_card).permit(
      :user_id, :number, :exp, :holder_name, :cvc
    )
  end
end
