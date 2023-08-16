class Admin::HeaderComponent < ViewComponent::Base
  def initialize(current_admin:)
    @current_admin = current_admin
  end
end
