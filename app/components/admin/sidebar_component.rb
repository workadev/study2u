class Admin::SidebarComponent < ViewComponent::Base
  include MenuHelper

  def initialize(current_admin:)
    @current_admin = current_admin
  end
end
