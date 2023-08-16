class Api::Users::V1::CurrentController < Api::UsersController
  before_action :find_object

  private

  def find_object
    @object = current_user
  end

  def object_params
    begin
      # handle error update image, not triggered callback
      params[:user][:updated_at] = Time.now.utc if params.dig("user", "avatar_id").present?
      params.require(:user).permit(:avatar_id, :avatar_data, :first_name, :last_name, :headline, :about_me, :email, :password, :phone_number, :address, :birthday, :updated_at)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
