module ParameterSignator
  extend ActiveSupport::Concern

  def assign_params(params, nested_name, opt={})
    if params.present? && params[nested_name].present?
      if params[nested_name].as_json.class.eql?(Hash)
        params[nested_name] = params[nested_name].merge(opt)
      else
        params[nested_name].each do |t|
          opt.each do |k, v|
            t[k] = v
          end
        end
      end
    end
  end
end