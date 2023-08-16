module Uploadable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_file
  end

  private

  def generate_file
    fields = self.class::ATTACHMENTS[class_name.to_sym]
    BaseUploader.generate_json_data(object: self, fields: fields) if fields.present?
  end
end
