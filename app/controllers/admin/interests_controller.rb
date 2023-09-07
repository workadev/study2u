class Admin::InterestsController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Interest.all
  end

  def set_class
    @class = Interest
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_interests_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_interest_path", @object.id) : @success_redirect
  end

  def set_config
    @config = { partial: "interest", options: { locals: { "interest": @object } } }
  end

  def config_show
    @options = { headers: (Interest.column_names - ["id"]).map { |s| s.underscore.humanize.capitalize.gsub("data", "") }, options: { object: @object, images: { icon: { alt: "Icon" } } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path }
  end

  def find_object
    @object = Interest.find_by(id: params[:id])
  end

  def object_params
    params.require(:interest).permit(:name, :icon_color, :icon)
  end
end
