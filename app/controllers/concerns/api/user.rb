module Api::User
  extend ActiveSupport::Concern

  def user
    current_user || current_staff
  end
end
