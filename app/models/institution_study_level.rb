# == Schema Information
#
# Table name: institution_study_levels
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :uuid
#  study_level_id :uuid
#
# Indexes
#
#  index_institution_study_levels_on_institution_id  (institution_id)
#  index_institution_study_levels_on_study_level_id  (study_level_id)
#  institution_study_level_institution               (study_level_id,institution_id) UNIQUE
#
class InstitutionStudyLevel < ApplicationRecord
  belongs_to :institution
  belongs_to :study_level

  validates_uniqueness_of :institution_id, scope: :study_level_id, message: "Already choosed"
end
