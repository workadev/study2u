class Admin::BranchesController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :set_parent

  private

  def set_index
    @query = Branch.includes(:major)
  end

  def set_class
    @class = Branch
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_branches_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_branch_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "branch", options: { locals: { "branch": @object } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path, majors: Major.all }
  end

  def find_object
    @object = Branch.find_by(id: params[:id])
  end

  def object_params
    params.require(:branch).permit(:name, :major_id)
  end
end
