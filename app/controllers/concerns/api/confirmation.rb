module Api::Confirmation
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!
    skip_before_action :find_object
    before_action :find_user, only: :create
  end

  def create
    @current_user.send_confirmation_instructions
    set_response(message: "Email verification instruction has been send to your email '#{@current_user.email}'")
  end

  def show
    user = user_or_staff.confirm_by_token(confirmation_params[:token])
    if user.errors.empty?
      set_response(message: "Your email has been confirmed")
    else
      set_response(message: "Error when confirm an email: #{user.errors.full_messages.join(" and ")}", status: 400)
    end
  end

  private

  def find_user
    return set_response(message: "Required params: email", status: 400) if params[:email].blank?
    @current_user = user_or_staff.find_by_email(params[:email])
    return set_response(message: "#{user_or_staff.to_s} not found", status: 400) if @current_user.blank?
  end

  def confirmation_params
    begin
      params.permit(:token)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
