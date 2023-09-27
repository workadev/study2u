class Admin::ArticlesController < AdminController
  before_action :set_redirect
  before_action :render_not_found, except: [:index, :new, :create]
  before_action :set_index, only: [:index, :create, :update]
  before_action :set_class, only: [:new, :create, :update, :destroy]
  before_action :set_config, only: :update
  before_action :config_show, only: :show
  before_action :set_parent, except: :show

  def new
    super { |resource| resource.images.build }
  end

  def edit
    super { |resource| resource.images.build if resource.images.blank? }
  end

  private

  def set_index
    if current_admin_panel.is_a?(Staff)
      @query = Article.where("userable_id = ? AND userable_type = ?", current_admin_panel.id, "Staff")
    else
      @query = Article.all
    end
  end

  def set_class
    @class = Article
  end

  def set_redirect
    @success_redirect = send("#{current_admin_panel.class_name}_articles_path")
    @redirect_path = ["edit", "update"].include?(params[:action]) ? send("#{current_admin_panel.class_name}_article_path", @object) : @success_redirect
  end

  def set_config
    @config = { partial: "article", options: { locals: { "article": @object } } }
  end

  def config_show
    @options = { headers: ["Title", "Subtitle", "Content", "Images"], options: { object: @object, relations: { images: { field: "image_data", return_list: true, image: true } }, raw: { content: {} } } }
  end

  def set_parent
    institutions = current_admin.present? ? Institution.all : Institution.by_created_by_id(current_staff.id, "Staff")
    @parent = { redirect_url: @redirect_path, institutions: institutions }
  end

  def find_object
    @object = Article.find_by(id: params[:id])
  end

  def object_params
    required = params.require(:article).permit(:title, :subtitle, :content, images_attributes: [ :id, :image, :_destroy ])
    required.merge!({ userable: current_admin_panel }) if params[:action] == "create"
    required
  end
end
