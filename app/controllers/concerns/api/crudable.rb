module Api::Crudable
  extend ActiveSupport::Concern

  included do
    before_action :find_object, only: [:show, :update, :destroy]
  end

  def index
    @query = paginate @query, per_page: params[:per_page], page: params[:page] rescue nil if params[:per_page].present? && params[:page].present?
    set_response(data: get_resource(object: @query), message: "Success get #{humanize_object_class_name}", status: 200)
  end

  def create(with_auth: false)
    begin
      object = @class.new(object_params)
      if object.save
        data = with_auth.to_s.eql?("true") ? with_authentication(object: object) : get_resource(object: object)
        set_response(data: data, message: "Success create #{humanize_object_class_name}", status: 201)
      else
        set_response(message: object.errors.full_messages.join(", "), status: 400)
      end
    rescue ActiveRecord::NestedAttributes::TooManyRecords => e
      set_response(message: e.message, status: 400)
    end
  end

  def with_authentication(object:)
    @user = object
    return authorize
  end

  def show
    set_response(data: get_resource(object: @object), message: "Success get detail #{humanize_object_class_name}", status: 200)
  end

  def update
    begin
      if @object.update(object_params)
        after_update
        set_response(data: get_resource(object: @object), message: "Success update #{humanize_object_class_name}", status: 200)
      else
        set_response(message: @object.errors.full_messages.join(", "), status: 400)
      end
    rescue ActiveRecord::NestedAttributes::TooManyRecords => e
      set_response(message: e.message, status: 400)
    end
  end

  def destroy
    if @object.destroy
      set_response(message: "Success delete #{humanize_object_class_name}")
    else
      set_response(message: @object.errors.full_messages.join(", "), status: 400)
    end
  end

  private

  def object_class_name
    @object.present? ? @object.class.name : !@query.nil? ? @query.klass.name : @class.present? ? @class.name : nil
  end

  def humanize_object_class_name
    object_class_name.split("::").last.underscore.humanize.downcase rescue nil
  end

  def get_resource(object:)
    unless @no_content
      resource_name = @resource_name.present? ? @resource_name.to_s : "#{object_class_name}Resource"
      @resource_params = @resource_params || {}
      Oj.load(resource_name.constantize.new(object, params: { current_user: current_user }.merge(@resource_params)).serialize) unless object.nil?
    end
  end

  def after_update;end
end
