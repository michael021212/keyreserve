module API
  module V1
    class Users < Grape::API
      resource :users do
        # ユーザ作成
        params do
          requires :email, type: String
          requires :name, type: String
        end
        post '/', jbuilder: 'users/create' do
          begin
            ActiveRecord::Base.transaction do
              @user = User.new(
                email: params[:email],
                corporation_id: @corporation.id,
                state: User.states[:activated],
                name: params[:name],
                sms_verified: true,
                password: decrypt(params[:password])
              )
              @user.save!
            end
          rescue => e
            @e = e
          end
        end
      end
    end
  end
end
