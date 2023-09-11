# == Schema Information
#
# Table name: major_interests
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  interest_id :uuid
#  major_id    :uuid
#
# Indexes
#
#  index_major_interests_on_interest_id               (interest_id)
#  index_major_interests_on_major_id                  (major_id)
#  index_major_interests_on_major_id_and_interest_id  (major_id,interest_id) UNIQUE
#
class MajorInterest < ApplicationRecord
  belongs_to :major
  belongs_to :interest

  validates_uniqueness_of :interest_id, scope: :major_id, message: "Already choosed"
end
