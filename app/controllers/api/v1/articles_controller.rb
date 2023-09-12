class Api::V1::ArticlesController < ApiController
  before_action :query_objects, only: :index

  private

  def query_objects
    @query = Article.includes(:images)
  end

  def find_object
    @object = Article.find_by_id(params[:id])
    return set_response(message: "Article is not found", status: 404) if @object.blank?
  end
end
