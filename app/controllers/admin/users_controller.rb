class Admin::UsersController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: :index
  before_action :set_index, only: :index
  before_action :config_show, only: :show

  private

  def set_index
    @query = User.all
  end

  def set_redirect
    @redirect_path = @success_redirect = send("#{current_admin_panel.class_name}_users_path")
  end

  def config_show
    @options = { headers: ["Email", "Avatar", "First Name", "Last Name", "Headline", "About Me", "Phone Number", "Address", "Birthday"], options: { object: @object, images: { avatar: { alt: "Avatar" } }} }
  end

  def find_object
    @object = User.find_by(id: params[:id])
  end
end
