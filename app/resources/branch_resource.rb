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
class BranchResource < BaseResource
  attributes :id, :name
end
