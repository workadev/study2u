class Api::Staffs::V1::ArticlesController < Api::StaffsController
  before_action :query_objects, only: :index

  private

  def query_objects
    @query = current_staff.articles.includes(:images)
  end
end
