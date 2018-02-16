class Users::ApplicationController < ApplicationController
  layout 'users/layouts/application'
  before_action :require_login
end
