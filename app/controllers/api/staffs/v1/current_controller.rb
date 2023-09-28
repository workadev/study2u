class Api::Staffs::V1::CurrentController < Api::StaffsController
  before_action :find_object

  def update_password
  end

  private

  def find_object
    @object = current_staff
  end

  def object_params
    if ["password"].include?(path_last)
      send("#{path_last}_params")
    else
      staff_params
    end
  end

  def staff_params
    begin
      # handle error update image, not triggered callback
      params[:staff][:updated_at] = Time.now.utc if params.dig("staff", "avatar_id").present?
      params.require(:staff).permit(:avatar_id, :avatar_data, :first_name, :last_name, :description, :nationality, :email, :password, :phone_number, :birthday, :updated_at, :current_qualification_id, :title)
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
end
