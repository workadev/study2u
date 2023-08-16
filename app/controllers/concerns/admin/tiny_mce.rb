module Admin::TinyMce
  extend ActiveSupport::Concern

  def helper_tinymce(file:)
    uploader = ImageUploader.new(:store)
    result = uploader.upload(file, upload_options: { server_side_encryption: "AES256", acl: "public-read" })
    result.try(:url).try(:split, "?").try(:first)
  end
end
