module API
  module V1
    module Helpers
      module AuthenticateHelper
        def login(email, pass)
          user = User.find_by(email: email)
          return false if user.blank?
          user.valid_password?(pass)
        end
      end
    end
  end
end
