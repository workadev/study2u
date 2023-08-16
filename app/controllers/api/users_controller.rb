class Api::UsersController < ApiController
  attr_reader :current_user

  before_action :authenticate_request!
end
