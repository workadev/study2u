class Admin::RegistrationsController < Devise::RegistrationsController
  helper_method :current_admin_panel

  layout "admin"

  private

  def current_admin_panel
    current_admin || current_staff
  end

  protected

  def after_update_path_for(resource)
    admin_dashboards_path
  end
end
