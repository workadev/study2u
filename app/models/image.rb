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
class Image < ApplicationRecord
  include ImageUploader.attachment(:image)

  # imageable with article
  belongs_to :imageable, polymorphic: :true, optional: true

  validates_presence_of :image_data
end
