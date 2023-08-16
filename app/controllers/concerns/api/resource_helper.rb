module Api::ResourceHelper
  def retrieve_url(url:)
    url.try(:split, "?").try(:first) if url.present?
  end
end
