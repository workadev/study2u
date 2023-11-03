class Api::Staffs::V1::InstitutionsController < Api::StaffsController
  before_action :query_objects, only: :index
  before_action :setup_resource_params, only: :index

  private

  def query_objects
    @query = current_staff.institutions.includes(:state, :majors, :study_levels, :interests)
  end

  def setup_resource_params
    @resource_params = {} if @resource_params.blank?
    includes = ["institutions.majors", "institutions.study_levels", "institutions.interests"]
    @resource_params = @resource_params.merge({ include: includes })
  end
end
