module Admin::Crudable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_admin!, if: -> { request.path.split("/")[1] == "admin" }
    before_action :authenticate_staff!, if: -> { request.path.split("/")[1] == "staff" }
    before_action :find_object, only: [:show, :edit, :update, :destroy]
  end

  # notes: the module is overrideable
  # you can directly override the name
  # of the method function chaining to
  # the rest

  def index
    populate_objects

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "pagination",
          partial: "list",
          locals: { objects: @objects, pagy: @pagy, search: @search }
        )
      }
    end
  end

  def new
    @object = @class.new
    yield @object if block_given?
  end

  def create
    @object = @class.new(object_params)
    if @object.save
      render_success
    else
      render_error
    end
  end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("show", @object)
      end
    end
  end

  def edit
    yield @object if block_given?
  end

  def update
    if @object.update(object_params)
      render_success
    else
      render_error
    end
  end

  def destroy
    @object.destroy
    respond_to do |format|
      format.html { redirect_to @success_redirect }
      format.turbo_stream do
        flash.now[:notice] = "Successfully deleted #{@class.to_s.underscore.humanize}"
        render "shared/admin/turbo_stream/destroy"
      end
    end
  end

  private

  def populate_objects
    @config = {} if @config.blank?
    params[:q] = params[:q].try(:merge, s: "created_at desc") || {s: "created_at desc"} if params[:q].blank?
    @search = @query.ransack(params[:q])
    @search.sorts = @config[:sort] || "created_at desc" if @search.sorts.empty?
    @pagy, @objects = pagy(
      @search.result,
      link_extra: 'data-turbo-frame="pagination" class="page-link"',
      page_param: :page,
      items: @config[:items] || 10,
      request_path: @redirect_path,
      params: { q: params[:q].permit!.to_h }
    )
  end

  def render_not_found
    if @object.blank?
      if request.format.turbo_stream?
        set_index
        populate_objects
      end

      respond_to do |format|
        set_redirect if @success_redirect.blank?
        format.html { redirect_to @success_redirect, alert: "Object not found", status: :not_found }
        format.turbo_stream do
          flash.now[:alert] = "Object not found"
          render "shared/admin/turbo_stream/not_found"
        end
      end
    end
  end

  def render_success(action: nil)
    respond_to do |format|
      action = params[:action] if action.blank?
      populate_objects if request.format.turbo_stream?
      format.html { redirect_to @success_redirect, notice: "Successfully #{action} #{@class.to_s.underscore.humanize}" }
      format.turbo_stream do
        flash.now[:notice] = "Successfully #{action} #{@class.to_s.underscore.humanize}"
        render "shared/admin/turbo_stream/#{action}"
      end
    end
  end

  def render_error(errors: nil)
    respond_to do |format|
      @parent = {} if @parent.blank?
      @errors = errors || @object.errors
      format.html { redirect_to @redirect_path, alert: @errors, status: :unprocessable_entity }
      format.turbo_stream { render "shared/admin/turbo_stream/error", status: :unprocessable_entity }
    end
  end
end
