class Api::V1::StudyLevelsController < ApiController
  before_action :query_objects, only: :index

  private

  def query_objects
    @query = StudyLevel.all
  end

  def find_object
    @object = StudyLevel.find_by_id(params[:id])
    return set_response(message: "Study level is not found", status: 404) if @object.blank?
  end
end
