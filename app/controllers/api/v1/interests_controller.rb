class Api::V1::InterestsController < ApiController
  before_action :query_objects, only: :index

  private

  def query_objects
    @query = Interest.all
  end

  def find_object
    @object = Interest.find_by_id(params[:id])
    return set_response(message: "Interest is not found", status: 404) if @object.blank?
  end
end
