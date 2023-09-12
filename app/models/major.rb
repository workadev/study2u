# == Schema Information
#
# Table name: majors
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Major < ApplicationRecord
  has_many :branches, dependent: :destroy

  has_many :major_interests, dependent: :destroy
  has_many :interests, through: :major_interests

  has_many :institution_majors, dependent: :destroy
  has_many :institutions, through: :institution_majors

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
end
