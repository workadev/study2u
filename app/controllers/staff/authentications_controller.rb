class Staff::AuthenticationsController < AdminController
  skip_before_action :authenticate_staff!
  skip_before_action :authorize!
  skip_before_action :find_object

  before_action :validate_token

  def show
    if @current_staff.present?
      bypass_sign_in(@current_staff)
      redirect_to staff_dashboards_path, notice: "Successfully sign in"
    else
      invalid_token
    end
  end

  private

  def validate_token
    if user_id_in_token? && auth_token.present?
      id = auth_token[:staff_id]
      @current_staff = Staff.where("id::text = ?", id).first
    else
      invalid_token
    end
  end

  def user_id_in_token?
    staff_id = auth_token[:staff_id].present? if auth_token.present?
    params[:token] && auth_token && staff_id
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(params[:token])
  end

  def invalid_token
    redirect_to new_staff_session_path, alert: "Token is invalid"
  end
end
