class Staff::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy

  layout "auth_admin"

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || staff_dashboards_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_staff_session_path
  end
end
