class Corporation::Base < ApplicationController
  layout 'corporation/layouts/application'

  # private
  #
  # def authenticate_corporation
  #   return if current_coporation.present?
  #   redirect_to corporation_sign_in_path, danger: 'Hoge'
  # end
end
