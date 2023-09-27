class Api::Staffs::V1::RegistrationsController < Api::StaffsController
  skip_before_action :authenticate_request!
  before_action :set_class

  private

  def set_class
    @class = Staff
  end

  def object_params
    begin
      params.require(:staff).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_qualification_id, :nationality, :tnc).merge({ registration: true, role_id: Role.find_by_name("Staff Admin").try(:id) })
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
