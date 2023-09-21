class Api::V1::MentorsController < ApiController
  before_action :query_objects, only: :index
  before_action :setup_resource_params

  private

  def query_objects
    @query = Staff.includes(:institutions)
  end

  def find_object
    @object = Staff.find_by_id(params[:id])
    return set_response(message: "Mentor is not found", status: 404) if @object.blank?
  end

  def setup_resource_params
    @resource_params = { include: ["staffs.institutions"] }
  end
end
