class Api::StaffsController < ApiController
  attr_reader :current_staff

  before_action :authenticate_request!
end
