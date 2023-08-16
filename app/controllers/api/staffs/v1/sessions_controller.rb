class Api::Staffs::V1::SessionsController < Api::StaffsController
  skip_before_action :authenticate_request!, only: :create
  skip_before_action :find_object

  before_action :check_mac_address, only: :create

  def create
    @staff = Staff.find_for_database_authentication({ email: params[:email] })
    if @staff.present? && @staff.valid_password?(params[:password])
      if @staff.confirmed?
        set_response(data: authorize, message: "Successfully login to the app")
      else
        set_response(message: "You must confirm your email first", status: 400)
      end
    else
      set_response(message: "Invalid: email / password", status: 400)
    end
  end

  def refresh_token
    current_device.update_column(:refresh_token, SecureRandom.uuid)
    authorize(mac_address: current_device.mac_address)
    head :no_content
  end

  def destroy
    current_device.update(status: "signout")
    sign_out(current_device.scope)
    set_response(message: "Successfully sign out")
  end
end
