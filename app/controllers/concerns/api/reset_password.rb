module Api::ResetPassword
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: [:create, :edit]
    skip_before_action :find_object
    before_action :render_missing_parameter, only: [:create, :edit]
    before_action :check_mac_address, only: :edit
  end

  def create
    user = user_or_staff.where("lower(email) = ?", params[:email].try(:downcase).try(:strip)).first
    if user.present?
      user.send_reset_password_instructions
      set_response(message: "Reset password instruction has been sent to your email '#{user.email}'")
    else
      set_response(message: "#{user_or_staff.to_s} not found", status: 400)
    end
  end

  def edit
    @user = user_or_staff.with_reset_password_token(params[:token])
    if @user.present?
      if @user.reset_password_period_valid?
        set_response(data: authorize(reset_password: true), message: "Successfully get token to reset password")
      else
        set_response(message: "Expired token", status: 400)
      end
    else
      set_response(message: "#{user_or_staff.to_s} not found", status: 400)
    end
  end

  def update
    return set_response(message: "Password and password_confirmation cannot be blank", status: 400) if update_password_params.blank? || update_password_params[:password].blank? || update_password_params[:password_confirmation].blank?
    if current_user.update(update_password_params)
      current_device.update(reset_password: false, status: "signout")
      sign_out(:user)
      set_response(message: "Successfully reset your password")
    else
      set_response(message: "Error: #{current_user.errors.full_messages.join(" and ")}")
    end
  end

  private

  def render_missing_parameter
    return set_response(status: 400, message: "Required params: email") if params[:email].blank? && params[:action].eql?("create")
    return set_response(status: 400, message: "Required params: token") if params[:token].blank? && params[:action].eql?("edit")
  end

  def update_password_params
    begin
      params.require(user_or_staff.to_s.downcase.to_sym).permit(:password, :password_confirmation).merge({ reset_password: true })
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
