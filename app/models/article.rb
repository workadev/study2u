# == Schema Information
#
# Table name: articles
#
#  id             :uuid             not null, primary key
#  content        :text
#  subtitle       :string
#  title          :string
#  userable_type  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :uuid
#  userable_id    :uuid
#
# Indexes
#
#  index_articles_on_institution_id                 (institution_id)
#  index_articles_on_userable_id_and_userable_type  (userable_id,userable_type)
#
class Article < ApplicationRecord
  belongs_to :userable, polymorphic: true
  belongs_to :staff, foreign_key: "userable_id", class_name: "Staff", optional: true
  belongs_to :institution, optional: true

  has_many :images, -> { where(imageable_type: "Article") }, foreign_key: "imageable_id", dependent: :destroy

  validates_presence_of :title, :subtitle, :content
  validates_presence_of :institution_id, if: -> { userable.present? && userable.class.name == "Staff" }

  accepts_nested_attributes_for :images, allow_destroy: :true, reject_if: :all_blank
end
