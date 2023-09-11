class Admin::RolesController < AdminController
  skip_before_action :authorize!, only: :actions

  before_action :set_redirect, except: :actions
  before_action :render_not_found, except: [:index, :new, :create, :actions]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: [:show, :actions]

  def actions
    method_name = params[:is_staff].to_s.eql?("true") ? "staff_actions" : "all"
    @actions = Action.send(method_name)
    @actions = @actions.by_category
    respond_to :js
  end

  private

  def set_index
    @query = Role.all
  end

  def set_class
    @class = Role
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_roles_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_role_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "role", options: { locals: { "role": @object } } }
  end

  def config_show
    @options = { headers: ["Name", "Actions"], options: { object: @object, relations: { actions: { field: "name", return_list: true } } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path, actions: Action.by_category }
  end

  def find_object
    @object = Role.find_by(id: params[:id])
  end

  def object_params
    params.require(:role).permit(:name, :is_staff, action_ids: [])
  end
end
