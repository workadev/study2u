class Api::Staffs::V1::CurrentController < Api::StaffsController
  before_action :find_object

  private

  def find_object
    @object = current_staff
  end

  def object_params
    begin
      # handle error update image, not triggered callback
      # params[:staff][:updated_at] = Time.now.utc if params.dig("staff", "avatar_id").present?
      params.require(:staff).permit()
    rescue ActionController::ParameterMissing => e
      return {}
    end
  end
end
