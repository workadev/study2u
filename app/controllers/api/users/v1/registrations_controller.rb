class Api::Users::V1::RegistrationsController < Api::UsersController
  skip_before_action :authenticate_request!
  before_action :set_class

  private

  def set_class
    @class = User
  end

  def object_params
    begin
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_education_id, :nationality, :tnc, interest_ids: []).merge({ registration: true })
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
