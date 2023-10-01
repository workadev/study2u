class Api::Staffs::V1::MentorsController < Api::StaffsController
  before_action :query_objects, only: :index

  private

  def query_objects
    @query = Staff.joins(:institutions).where("institutions.id in (?)", current_staff.institution_ids).includes(:current_qualification)
  end
end
