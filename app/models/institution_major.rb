# == Schema Information
#
# Table name: institution_majors
#
#  id              :uuid             not null, primary key
#  duration_extra  :string
#  duration_normal :string
#  fee             :integer
#  intake          :string           is an Array
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  institution_id  :uuid
#  major_id        :uuid
#
# Indexes
#
#  index_institution_majors_on_institution_id               (institution_id)
#  index_institution_majors_on_major_id                     (major_id)
#  index_institution_majors_on_major_id_and_institution_id  (major_id,institution_id) UNIQUE
#
class InstitutionMajor < ApplicationRecord
  INTAKES = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

  belongs_to :institution
  belongs_to :major

  validates_uniqueness_of :institution_id, scope: :major_id, message: "Already choosed"

  before_save :check_intakes

  def check_intakes
    self.intake = self.intake.reject { |c| c.empty? } if intake.present?
  end
end
