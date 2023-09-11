# == Schema Information
#
# Table name: study_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StudyLevel < ApplicationRecord
  has_many :institution_study_levels, dependent: :destroy
  has_many :institutions, through: :institution_study_levels

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
end
