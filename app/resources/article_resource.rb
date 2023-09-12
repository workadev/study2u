# == Schema Information
#
# Table name: articles
#
#  id         :uuid             not null, primary key
#  content    :text
#  subtitle   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArticleResource < BaseResource
  many :images, resource: ImageResource

  attributes :id, :title, :subtitle, :content
end
