module UserHelper
  
  def select_user_type_without_parent_corporation
    [['利用者', 'personal'], ['施設管理者', 'corporate_admin']]
  end
end
