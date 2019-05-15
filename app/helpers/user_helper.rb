module UserHelper
  
  def select_user_type_without_parent_corporation
    [
      [I18n.t('enums.user.user_type.personal'), 'personal'],
      [I18n.t('enums.user.user_type.corporate_admin'), 'corporate_admin']
    ]
  end
end
