# == Schema Information
#
# Table name: branches
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  major_id   :uuid
#
# Indexes
#
#  index_branches_on_major_id  (major_id)
#
class Branch < ApplicationRecord
  belongs_to :major

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false, scope: :major_id
end
