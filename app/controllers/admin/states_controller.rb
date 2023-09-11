class Admin::StatesController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :set_parent

  private

  def set_index
    @query = State.all
  end

  def set_class
    @class = State
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_states_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_state_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "state", options: { locals: { "state": @object } } }
  end

  def set_parent
    @parent = { redirect_url: @redirect_path }
  end

  def find_object
    @object = State.find_by(id: params[:id])
  end

  def object_params
    params.require(:state).permit(:name)
  end
end
