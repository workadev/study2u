class Admin::StaffsController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  private

  def set_index
    @query = Staff.all
  end

  def set_class
    @class = Staff
  end

  def set_redirect
    @success_redirect = admin_staffs_path
    @redirect_path = ["edit", "update"].include?(params[:action]) ? admin_staff_path(@object.id) : admin_staffs_path
  end

  def set_config
    @config = { partial: "staff", options: { locals: { "staff": @object } } }
    params[:staff].delete(:password) if params[:staff].present? && params[:staff][:password].blank?
  end

  def config_show
    @options = { headers: ["Email", "Avatar", "First Name", "Last Name", "Title", "Description", "Phone Number", "Institutions"], options: { object: @object, relations: { institutions: { field: "name", return_list: true } }, images: { avatar: { alt: "Avatar" } } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path, institutions: Institution.all }
  end

  def find_object
    @object = Staff.find_by(id: params[:id])
  end

  def object_params
    params.require(:staff).permit(:first_name, :last_name, :email, :password, :avatar, :title, :description, :phone_number, institution_ids: []).merge(create_by_admin: true)
  end
end
