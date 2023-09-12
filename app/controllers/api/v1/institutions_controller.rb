class Api::V1::InstitutionsController < ApiController
  before_action do
    authenticate_request!(validate: ["shortlist", "unshortlist"].include?(action_name))
  end

  before_action :set_callback_method, only: [:index, :recommendations, :compares]
  before_action :find_object, only: [:show, :shortlist, :unshortlist]
  before_action :query_objects, only: [:index, :recommendations]
  before_action :search_institutions, only: :compares
  before_action :setup_resource_params

  def compares
    index
  end

  def recommendations
    index
  end

  def shortlist
    current_user.user_institutions.create(institution_id: @object.id)
    head :no_content
  end

  def unshortlist
    UserInstitution.find_by_user_id_and_institution_id(current_user.id, @object.id).try(:destroy)
    head :no_content
  end

  private

  def query_objects
    @query = path_last == "recommendations" ? Institution.recommendations(user_id: current_user&.id) : Institution.get(params: params)
    @query = @query.includes(:state, :majors, :study_levels)
  end

  def search_institutions
    @query = Institution.where("id IN (?)", params[:ids])
    return set_response(message: "Some institutions are not found", status: 404) if @query.blank? || @query.count != params[:ids].count
  end

  def find_object
    @object = Institution.find_by_id(params[:id])
    return set_response(message: "Institution is not found", status: 404) if @object.blank?
  end

  def setup_resource_params
    @resource_params = {} if @resource_params.blank?

    includes = ["institutions.majors", "institutions.study_levels"]
    includes += ["institutions.images", "institutions.interests"] if action_name == "show"
    @resource_params = @resource_params.merge({ include: includes })

    if action_name == "show"
      institution_ids = current_user.present? ? current_user.institutions.pluck(:id) : []
      @resource_params.merge!({ institution_ids: institution_ids })
    elsif action_name == "compares"
      params[:per_page] = nil
      params[:page] = nil
    end
  end

  def set_callback_method
    @callback = { callback: "shortlisted_users" }
  end
end
