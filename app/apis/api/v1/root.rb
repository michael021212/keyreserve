module API
  module V1
    class Root < Grape::API
      CIPHER = "aes-256-cbc"

      # http://localhost:3000/api/v1/
      version 'v1', using: :path
      format :json
      formatter :json, Grape::Formatter::Jbuilder

      helpers do
        def jwt_authenticate
          error!('Unauthorized token.', 401) unless jwt_bearer_token
          #error!('Unauthorized token.', 401) unless jwt_decoded_token
        end

        def jwt_bearer_token
          return if request.headers['Authorization'].blank?
          scheme, token = request.headers['Authorization'].split(' ')

          @corporation = Corporation.find_by(jwt_token: token)
          @jwt_bearer_token ||= scheme == 'Bearer' ? token : nil
        end

        def jwt_decoded_token
          @jwt_decoded_token ||= JWT.decode(jwt_bearer_token, Rails.application.secrets.secret_key_base, algorithm: 'HS256')
        rescue JWT::DecodeError, JWT::VerificationError, JWT::InvalidIatError => e
          Rails.logger.error(e.message)
          Rails.logger.error e.backtrace.join("\n")
          nil # エラーの詳細をクライアントには伝えないため、常に nil を返す
        end

        # 文字列をパートナー毎のtokenでエンコード
        def encrypt(value)
          return if @corporation.blank?
          secure = @corporation.jwt_token
          crypt = ActiveSupport::MessageEncryptor.new(secure[0..31], CIPHER)
          crypt.encrypt_and_sign(value)
        end

        # ハッシュ形式で送られてきた文字列をデコード
        def decrypt(value)
          return if @corporation.blank?
          secure = @corporation.jwt_token
          crypt = ActiveSupport::MessageEncryptor.new(secure[0..31], CIPHER)
          crypt.decrypt_and_verify(value)
        end

        # メッセージ付きでエラーを返す
        def raise_with_message(msg, code)
          error!({errors: msg}, code)
        end
      end

      before do
        jwt_authenticate
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        Rails.logger.error(e.message)
        Rails.logger.error e.backtrace.join("\n")
        rack_response({ message: e.message, status: 400 }.to_json, 400)
      end

      rescue_from :all do |e|
        Rails.logger.error(e.message)
        Rails.logger.error e.backtrace.join("\n")
        rack_response({ message: e.message, status: 500 }.to_json, 500)
      end

      mount API::V1::FacilityKeys
      mount API::V1::Users
      mount API::V1::Sessions
    end
  end
end

