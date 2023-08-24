# == Schema Information
#
# Table name: institution_interests
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :bigint
#  interest_id    :bigint
#
# Indexes
#
#  index_institution_interests_on_institution_id                  (institution_id)
#  index_institution_interests_on_institution_id_and_interest_id  (institution_id,interest_id) UNIQUE
#  index_institution_interests_on_interest_id                     (interest_id)
#
class InstitutionInterest < ApplicationRecord
  belongs_to :institution
  belongs_to :interest

  validates_uniqueness_of :interest, scope: :institution, message: "Already choosed"
end
