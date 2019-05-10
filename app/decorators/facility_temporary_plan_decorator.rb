class FacilityTemporaryPlanDecorator < Draper::Decorator
  delegate_all
  
  def display_plan_name
    plan_name.present? ? plan_name : I18n.t('common.not_member')
  end
end
