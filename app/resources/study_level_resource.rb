# == Schema Information
#
# Table name: study_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StudyLevelResource < BaseResource
  attributes :id, :name
end
