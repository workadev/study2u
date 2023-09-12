# == Schema Information
#
# Table name: interests
#
#  id         :uuid             not null, primary key
#  icon_color :string
#  icon_data  :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class InterestResource < BaseResource
  attributes :id, :icon_color, :name

  attribute :icon do |resource|
    retrieve_url(url: resource.icon_url)
  end
end
