require 'sorcery'

module API
  module V1
    class Sessions < Grape::API
      helpers API::V1::Helpers::AuthenticateHelper

      resource :sessions do
        # ログイン
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post '/', jbuilder: 'sessions/create' do
          begin
            @user = User.find_by(email: params[:email])
            @result = login(params[:email], decrypt(params[:password]))
          rescue => e
            @e = e
          end
        end
      end
    end
  end
end

