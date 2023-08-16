class Admin::SessionsController < Devise::SessionsController
  layout "auth_admin"

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_dashboards_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
