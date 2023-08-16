class ApiController < ActionController::API
  attr_reader :current_device

  include Api::Authentication
  include Api::Crudable
  include ParameterSignator
  include RequestHelper
end
