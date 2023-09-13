# == Schema Information
#
# Table name: videos
#
#  id             :uuid             not null, primary key
#  video_data     :text
#  videoable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  videoable_id   :uuid
#
# Indexes
#
#  index_videos_on_videoable_type_and_videoable_id  (videoable_type,videoable_id)
#
class Video < ApplicationRecord
  include VideoUploader.attachment(:video)

  # imageable with article
  belongs_to :videoable, polymorphic: :true, optional: true

  validates_presence_of :video_data

  def video_name
    video.metadata["filename"] if video.present?
  end
end
