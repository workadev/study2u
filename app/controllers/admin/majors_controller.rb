class Admin::MajorsController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Major.all
  end

  def set_class
    @class = Major
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_majors_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_major_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "major", options: { locals: { "major": @object } } }
  end

  def config_show
    @options = { headers: (Major.column_names - ["id"] + ["Interests"]).map { |s| s.underscore.humanize.capitalize }, options: { object: @object, relations: { interests: { field: "name", return_list: true } } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path, interests: Interest.all }
  end

  def find_object
    @object = Major.find_by(id: params[:id])
  end

  def object_params
    params.require(:major).permit(:name, interest_ids: [])
  end
end
