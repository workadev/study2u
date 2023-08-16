class Admin::RolesController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Role.all
  end

  def set_class
    @class = Role
  end

  def set_redirect
    @success_redirect = admin_roles_path
    @redirect_path = ["edit", "update"].include?(params[:action]) ? admin_role_path(@object.id) : admin_roles_path
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
    params.require(:role).permit(:name, action_ids: [])
  end
end
