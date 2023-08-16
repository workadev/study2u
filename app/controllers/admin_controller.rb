class AdminController < ActionController::Base
  include Admin::Crudable
  include ParameterSignator
  include RequestHelper
  include Pagy::Backend
  include Pundit::Authorization

  layout "admin"

  before_action :authorize!
  # before_action :ensure_frame_response, only: [:new, :edit]

  private

  def ensure_frame_response
    return unless Rails.env.development?
    redirect_to admin_dashboards_path unless turbo_frame_request?
  end

  protected

  def authorize!
    unless params[:controller].split("/").first.eql?("admin")
      policy = ApplicationPolicy.new(user: current_admin, controller: params[:controller].split("/").last, action: params[:action]).have_access?
      render file: "public/422.html", status: 422, layout: false if !policy
    end
  end
end
