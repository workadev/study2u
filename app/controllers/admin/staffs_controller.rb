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
    if current_admin_panel.is_a?(Staff)
      @query = Staff.joins(:institutions).where("institutions.created_by_id = ? AND institutions.created_by_type = ?", current_admin_panel.id, "Staff")
    else
      @query = Staff.all
    end
  end

  def set_class
    @class = Staff
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_staffs_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_staff_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "staff", options: { locals: { "staff": @object } } }
    params[:staff].delete(:password) if params[:staff].present? && params[:staff][:password].blank?
  end

  def config_show
    @options = { headers: ["Email", "Avatar", "First Name", "Last Name", "Title", "Description", "Phone Number", "Institutions", "Role Name", "Current Qualification Name", "Nationality"], options: { object: @object, relations: { institutions: { field: "name", return_list: true } }, images: { avatar: { alt: "Avatar" } } } }
  end

  def set_parent
    institutions = current_admin.present? ? Institution.all : Institution.by_created_by_id(current_staff.id, "Staff")
    @parent = { redirect_url: @redirect_path, institutions: institutions, roles: Role.staff_roles, study_levels: StudyLevel.all }
  end

  def find_object
    @object = Staff.find_by(id: params[:id])
  end

  def object_params
    params.require(:staff).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :avatar,
      :title,
      :description,
      :phone_number,
      :role_id,
      :nationality,
      :current_qualification_id,
      institution_ids: []).merge(create_by_admin: true)
  end
end
