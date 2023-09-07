class Admin::AdminsController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Admin.includes(:role)
  end

  def set_class
    @class = Admin
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_admins_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) && @object.present? ? send("#{current_admin_panel.class_name}_admin_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "admin", options: { locals: { "admin": @object } } }
    params[:admin].delete(:password) if params[:admin][:password].blank?
  end

  def config_show
    @options = { headers: ["Name", "Email", "Role Name", "Avatar"], options: { object: @object, images: { avatar: { alt: "Avatar" } }} }
  end

  def set_parent
    @parent = { roles: Role.all, redirect_url: @redirect_path }
  end

  def find_object
    @object = Admin.find_by(id: params[:id])
  end

  def object_params
    params.require(:admin).permit(:name, :email, :password, :role_id, :avatar, :name)
  end
end
