# == Schema Information
#
# Table name: images
#
#  id             :uuid             not null, primary key
#  image_data     :text
#  imageable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  imageable_id   :uuid
#
# Indexes
#
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#
class ImageResource < BaseResource
  attributes :id

  attribute :image do |resource|
    retrieve_url(url: resource.image_url)
  end
end
