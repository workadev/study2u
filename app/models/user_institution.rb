# == Schema Information
#
# Table name: user_institutions
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :uuid
#  user_id        :uuid
#
# Indexes
#
#  index_user_institutions_on_institution_id              (institution_id)
#  index_user_institutions_on_user_id                     (user_id)
#  index_user_institutions_on_user_id_and_institution_id  (user_id,institution_id) UNIQUE
#
class UserInstitution < ApplicationRecord
  belongs_to :user
  belongs_to :institution

  validates_uniqueness_of :user_id, scope: :institution_id, message: "Already choosed"
end
