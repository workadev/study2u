class AdminController < ActionController::Base
  helper_method :current_admin_panel

  include Admin::Crudable
  include ParameterSignator
  include RequestHelper
  include Pagy::Backend
  include Pundit::Authorization

  layout "admin"

  before_action :authorize!
  # before_action :ensure_frame_response, only: [:new, :edit]

  private

  def current_admin_panel
    current_admin || current_staff
  end

  def ensure_frame_response
    return unless Rails.env.development?

    redirect_to send("#{current_admin_panel.class_name}_dashboards_path") unless turbo_frame_request?
  end

  protected

  def authorize!
    unless params[:controller].split("/").first.eql?(current_admin_panel.class_name)
      policy = ApplicationPolicy.new(user: current_admin_panel, controller: params[:controller].split("/").last, action: params[:action]).have_access?
      render file: "public/422.html", status: 422, layout: false if !policy
    end
  end
end
