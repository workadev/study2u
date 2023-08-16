module ImageHelper
  def image_tag_url(object:, key_name:)
    key = key_name.chomp("_data")
    return object.try(key.to_sym).try(:url) || ""
  end
end
