class Api::Users::V1::CurrentController < Api::UsersController
  before_action :find_object
  before_action :setup_resource_params
  before_action :update, only: [:update_interests, :update_shortlists, :update_password]

  def update_interests
  end

  def update_shortlists
  end

  def update_password
  end

  private

  def find_object
    @object = current_user
  end

  def object_params
    if ["interests", "shortlists", "password"].include?(path_last)
      send("#{path_last}_params")
    else
      user_params
    end
  end

  def user_params
    begin
      # handle error update image, not triggered callback
      params[:user][:updated_at] = Time.now.utc if params.dig("user", "avatar_id").present?
      params.require(:user).permit(:avatar_id, :avatar_data, :first_name, :last_name, :headline, :about_me, :email, :password, :phone_number, :address, :birthday, :updated_at, :nationality, :current_school, :current_education_id)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end

  def interests_params
    begin
      params.require(:user).permit(interest_ids: [])
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end

  def shortlists_params
    begin
      params.require(:user).permit(institution_ids: [])
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end

  def password_params
    begin
      params.require(:user).permit(:current_password, :password, :password_confirmation).merge({ update_password: true })
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end

  def setup_resource_params
    @resource_params = { include: ["users.institutions", "users.interests"] }
  end
end
