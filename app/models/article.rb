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
class Article < ApplicationRecord
  has_many :images, -> { where(imageable_type: "Article") }, foreign_key: "imageable_id", dependent: :destroy

  validates_presence_of :title, :subtitle, :content

  accepts_nested_attributes_for :images, allow_destroy: :true, reject_if: :all_blank
end
