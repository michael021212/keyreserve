module Target
  extend ActiveSupport::Concern
  def target
    user.user_corp.present? ? user.user_corp : user
  end 
end
