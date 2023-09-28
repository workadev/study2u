module Api::RequestHelper
  include RequestHelper

  def user_or_staff
    request_path[2].singularize.capitalize.constantize
  end
end
