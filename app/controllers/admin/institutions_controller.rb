class Admin::InstitutionsController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Institution.all
  end

  def set_class
    @class = Institution
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_institutions_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_institution_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "institution", options: { locals: { "institution": @object } } }
  end

  def config_show
    @options = { headers: (Institution.column_names - ["id"]).map { |s| s.underscore.humanize.capitalize.gsub("data", "") }, options: { object: @object, relations: { interests: { field: "name", return_list: true } }, images: { logo: { alt: "Logo" } } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path, interests: Interest.all, staffs: Staff.all }
  end

  def find_object
    @object = Institution.find_by(id: params[:id])
  end

  def object_params
    required = params.require(:institution).permit(:name, :address, :area, :city, :country, :description, :short_desc, :logo, :latitude, :longitude, :ownership, :post_code, :reputation, :size, :state, :status, :institution_type, interest_ids: [], staff_ids: [])
    required.merge({ created_by: current_admin_panel }) if params[:action] == "create"
    required
  end
end
