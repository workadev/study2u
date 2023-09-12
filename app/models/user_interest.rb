# == Schema Information
#
# Table name: user_interests
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  interest_id :uuid
#  user_id     :uuid
#
# Indexes
#
#  index_user_interests_on_interest_id              (interest_id)
#  index_user_interests_on_user_id                  (user_id)
#  index_user_interests_on_user_id_and_interest_id  (user_id,interest_id) UNIQUE
#
class UserInterest < ApplicationRecord
  belongs_to :user
  belongs_to :interest

  validates_uniqueness_of :user_id, scope: :interest_id, message: "Already choosed"
end
