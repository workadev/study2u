class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  ATTACHMENTS = {
    staff: ["avatar_id"],
    user: ["avatar_id"]
  }

  def class_name
    @@class_name = self.class.name.gsub("::", "_").underscore
  end

  def to_string(datetime)
    return nil if datetime.blank?
    datetime.strftime("%Y-%m-%d %H:%M:%S GMT%z") rescue nil
  end

  def self.add_scope_and_check_method(constants:, field_name:, prefix: nil)
    constants.each do |constant_value|
      define_method "is_#{constant_value}?" do
        send(field_name).eql?(constant_value)
      end
      scope_name = prefix.present? ? "#{prefix.to_s}_#{constant_value}" : constant_value
      scope scope_name, -> { where("#{field_name}": constant_value) }
    end
  end
end
