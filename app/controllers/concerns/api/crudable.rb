module Api::Crudable
  extend ActiveSupport::Concern

  included do
    before_action :find_object, only: [:show, :update, :destroy]
  end

  def index
    paginate_query
    callback = run_callback(queries: @query, opt: @callback)
    setup_resource_params
    ActiveRecord::Associations::Preloader.new(records: @query, associations: @associations).call if @associations.present?
    set_response(data: get_resource(object: @query), message: "Success get #{humanize_object_class_name}", status: 200)
  end

  def create(with_auth: false)
    begin
      object = @class.new(object_params)
      if object.save
        after_create
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
      after_destroy
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
    @object_name.present? ? @object_name : object_class_name.split("::").last.underscore.humanize.downcase rescue nil
  end

  def get_resource(object:)
    unless @no_content
      object = object.reload if @reload.to_s.eql?("true")
      resource_name = @resource_name.present? ? @resource_name.to_s : "#{object_class_name}Resource"
      Oj.load(resource_name.constantize.new(object, params: default_params).serialize) unless object.nil?
    end
  end

  def default_params
    (@resource_params || {}).merge({ current_user: current_user || current_staff })
  end

  def object_not_found(object_name:)
    return set_response(status: 404, message: "#{object_name.to_s} with selected id is not found") if @object.blank?
  end

  def after_create;end

  def after_update;end

  def after_destroy;end

  def paginate_query
    if params[:per_page].present? && params[:page].present?
      begin
        options = { per_page: params[:per_page], page: params[:page] }
        if @group || @count.present?
          size = @query.size
          count = @count.present? ? @count : size.is_a?(Integer) ? size : size.size
          options = options.merge({ count: count })
        end
        @query = paginate(@query, **options)
      rescue StandardError => e
      end
    end
  end

  def setup_resource_params
  end

  def run_callback(queries:, opt: {})
    # This code is to get object_ids via queries and use it to get relations and send it to params
    # It use class method, single callback
    @resource_params = {} if @resource_params.blank?
    opt = {} if opt.blank?

    if opt[:callback].present?
      callbacks = opt[:callback].is_a?(String) ? [opt[:callback]] : opt[:callback]
      callbacks.each do |callback_name|
        object = opt[:class_name].present? ? opt[:class_name].to_s.constantize : queries.klass
        opt[:args] = {} if opt[:args].blank?

        if opt[:callback_field_name].is_a?(Hash)
          field_name = opt[:callback_field_name][callback_name] rescue :id
        elsif opt[:callback_field_name].is_a?(String)
          field_name = opt[:callback_field_name]
        end
        field_name = :id if field_name.blank?

        ids = queries.pluck(field_name)
        opt[:args] = opt[:args].merge({ ids: ids, current_user: current_user || current_staff })
        opt[:callback] = callback_name
        results = execute_callback(object, opt)
        opt[:params] = { current_user: current_user || current_staff } if opt[:params].blank?
        opt[:params] = opt[:params].merge(results) if results.class.eql?(Hash)
        @resource_params.merge!(results)
      end
    end
  end

  def execute_callback(object, opt={})
    conf = opt[:callback]
    args = opt[:args].is_a?(Array) ? opt[:args] : [opt[:args]] if opt.has_key?(:args)
    if conf.present?
      if conf.class.eql?(String)
        # This is for simple callback
        # only trigger instance method
        # return method cannot be modified
        object.send(conf, *args)
      elsif conf.class.eql?(Array) && conf.first.class.eql?(Hash)
        # can triggered multiple callback
        # each callback can be instance or class method
        # return of the method can be modified for ex: send as params to serializer
        opt[:params] = {} if opt[:params].blank?
        conf.each do |option|
          if option[:name].present?
            if option[:class_name].present?
              result = option[:class_name].constantize.send(option[:name], *option[:args])
            else
              obj = option[:class_method].to_s.eql?("true") ? object.class : object
              result = obj.send(option[:name], *option[:args])
            end
            opt[:params] = opt[:params].merge!({ "#{option[:as_params]}": result }) if option[:as_params].present?
          end
        end
      end
    end
  end
end
