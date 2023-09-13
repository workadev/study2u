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
class VideoResource < BaseResource
  attributes :id

  attribute :video do |resource|
    retrieve_url(url: resource.video_url)
  end
end
