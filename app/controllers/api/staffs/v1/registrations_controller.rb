class Api::Staffs::V1::RegistrationsController < Api::StaffsController
  skip_before_action :authenticate_request!
  before_action :check_mac_address
  before_action :set_class

  def create
    super(with_auth: true)
  end

  private

  def set_class
    @class = Staff
  end

  def object_params
    begin
      params.require(:staff).permit(:email, :password)
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
