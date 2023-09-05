# == Schema Information
#
# Table name: staff_institutions
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  institution_id :uuid
#  staff_id       :uuid
#
# Indexes
#
#  index_staff_institutions_on_institution_id  (institution_id)
#  index_staff_institutions_on_staff_id        (staff_id)
#
class StaffInstitution < ApplicationRecord
  belongs_to :institution
  belongs_to :staff

  validates_uniqueness_of :institution_id, scope: :staff_id, message: "Already choosed"
end
