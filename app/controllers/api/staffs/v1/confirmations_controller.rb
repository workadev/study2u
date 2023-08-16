class Api::Staffs::V1::ConfirmationsController < Api::StaffsController
  skip_before_action :authenticate_request!
  skip_before_action :find_object
  before_action :find_staff, only: :create

  def create
    @current_staff.send_confirmation_instructions
    set_response(message: "Email verification instruction has been send to your email '#{@current_staff.email}'")
  end

  def show
    staff = Staff.confirm_by_token(confirmation_params[:token])
    if staff.errors.empty?
      set_response(message: "Your email has been confirmed")
    else
      set_response(message: "Error when confirm an email: #{staff.errors.full_messages.join(" and ")}", status: 400)
    end
  end

  private

  def find_staff
    return set_response(message: "Required params: email", status: 400) if params[:email].blank?
    @current_staff = Staff.find_by_email(params[:email])
    return set_response(message: "Staff not found", status: 400) if @current_staff.blank?
  end

  def confirmation_params
    begin
      params.permit(:token)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
